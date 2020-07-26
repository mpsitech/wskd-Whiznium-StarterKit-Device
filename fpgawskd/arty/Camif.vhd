-- file Camif.vhd
-- Camif easy model controller implementation
-- author Catherine Johnson
-- date created: 16 May 2020
-- date modified: 16 May 2020

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Arty.all;

entity Camif is
	generic (
		fMclk: natural range 1 to 1000000 := 50000 -- in kHz
	);
	port (
		reset: in std_logic;
		mclk: in std_logic;
		tkclk: in std_logic;
		rng: out std_logic;

		reqInvSetRng: in std_logic;
		ackInvSetRng: out std_logic;

		setRngRng: in std_logic_vector(7 downto 0);

		reqInvSetFocus: in std_logic;
		ackInvSetFocus: out std_logic;

		setFocusVcm: in std_logic_vector(15 downto 0);

		reqInvSetTexp: in std_logic;
		ackInvSetTexp: out std_logic;

		setTexpTexp: in std_logic_vector(15 downto 0);

		reqInvSetReg: in std_logic;
		ackInvSetReg: out std_logic;

		setRegAddr: in std_logic_vector(15 downto 0);
		setRegVal: in std_logic_vector(7 downto 0);

		reqInvGetReg: in std_logic;
		ackInvGetReg: out std_logic;

		getRegAddr: in std_logic_vector(15 downto 0);
		getRegVal: out std_logic_vector(7 downto 0);

		reqInvModReg: in std_logic;
		ackInvModReg: out std_logic;

		modRegAddr: in std_logic_vector(15 downto 0);
		modRegMask: in std_logic_vector(7 downto 0);
		modRegVal: in std_logic_vector(7 downto 0);

		rst: out std_logic;
		pwdn: out std_logic;
		xclk: out std_logic;

		scl: out std_logic;
		sda: inout std_logic;

		stateOp_dbg: out std_logic_vector(7 downto 0)
	);
end Camif;

architecture Camif of Camif is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	component I2c is
		generic (
			fMclk: natural range 1 to 1000000;

			clkFastNotStd: std_logic := '1';
			clkFastplusNotFast: std_logic := '0';

			devaddr: std_logic_vector(7 downto 0) := "01111000"
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;

			req: in std_logic;
			ack: out std_logic;
			dne: out std_logic;

			readNotWrite: in std_logic;
			regaddr: in std_logic_vector(15 downto 0);
			send: in std_logic_vector(7 downto 0);
			recv: out std_logic_vector(7 downto 0);

			scl: out std_logic;
			sda: inout std_logic
		);
	end component;

	component Spbram_v1_0_size2kB is
		port (
			clk: in std_logic;

			en: in std_logic;
			we: in std_logic;

			a: in std_logic_vector(10 downto 0);
			drd: out std_logic_vector(7 downto 0);
			dwr: in std_logic_vector(7 downto 0)
		);
	end component;

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- camera master clock (camclk)

	signal xclk_sig: std_logic;

	-- IP sigs.camclk.cust --- INSERT

	---- main operation (op)
	type stateOp_t is (
		stateOpInit,
		stateOpPwupA, stateOpPwupB, stateOpPwupC, stateOpPwupD,
		stateOpLoadA, stateOpLoadB,
		stateOpXfer,
		stateOpStep,
		stateOpInv
	);
	signal stateOp: stateOp_t := stateOpInit;

	signal rng_sig: std_logic;
	signal rst_sig: std_logic;
	signal pwdn_sig: std_logic;
	signal ackInvSetRng_sig: std_logic;
	signal ackInvSetFocus_sig: std_logic;
	signal ackInvSetTexp_sig: std_logic;
	signal ackInvSetReg_sig: std_logic;
	signal ackInvGetReg_sig: std_logic;
	signal regVal: std_logic_vector(7 downto 0);
	signal ackInvModReg_sig: std_logic;
	signal enParrom: std_logic;

	signal aParrom_vec: std_logic_vector(10 downto 0);
	signal aParrom: natural range 0 to 2048;

	signal i2cReadNotWrite: std_logic;
	signal i2cRegaddr: std_logic_vector(15 downto 0);
	signal i2cSend: std_logic_vector(7 downto 0);

	-- IP sigs.op.cust --- INSERT

	---- myI2c
	signal i2cRecv: std_logic_vector(7 downto 0);

	---- myParrom
	signal drdParrom: std_logic_vector(7 downto 0);

	---- handshake
	-- op to myI2c
	signal reqI2c: std_logic;
	signal ackI2c: std_logic;
	signal dneI2c: std_logic;

	---- other
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myI2c : I2c
		generic map (
			fMclk => fMclk, -- in kHz

			clkFastNotStd => '1', -- 1Mbps/400kbps vs. 100kbps
			clkFastplusNotFast => '0', -- 1Mbps vs. 400kbps

			devaddr => "01111000" -- 0x78, not 0x3C as in Linux version
		)
		port map (
			reset => reset,
			mclk => mclk,

			req => reqI2c,
			ack => open,
			dne => dneI2c,

			readNotWrite => i2cReadNotWrite,
			regaddr => i2cRegaddr,
			send => i2cSend,
			recv => i2cRecv,

			scl => scl,
			sda => sda
		);

	myParrom : Spbram_v1_0_size2kB
		port map (
			clk => mclk,

			en => enParrom,
			we => '0',

			a => aParrom_vec,
			drd => drdParrom,
			dwr => (others => '0')
		);

	------------------------------------------------------------------------
	-- implementation: camera master clock (camclk)
	------------------------------------------------------------------------

	-- IP impl.camclk.wiring --- BEGIN
	xclk <= xclk_sig;
	-- IP impl.camclk.wiring --- END

	-- IP impl.camclk.rising --- BEGIN
	process (reset, mclk)
		-- IP impl.camclk.vars --- RBEGIN
		constant imax: natural := (fMclk/25000)/2;
		variable i: natural range 0 to imax;
		-- IP impl.camclk.vars --- REND

	begin
		if reset='1' then
			-- IP impl.camclk.asyncrst --- RBEGIN
			xclk_sig <= '0';
			i := 0;
			-- IP impl.camclk.asyncrst --- REND

		elsif rising_edge(mclk) then
			-- IP impl.camclk --- IBEGIN
			i := i + 1;
			if i=imax then
				xclk_sig <= not xclk_sig;
				i := 0;
			end if;
			-- IP impl.camclk --- IEND
		end if;
	end process;
	-- IP impl.camclk.rising --- END

	------------------------------------------------------------------------
	-- implementation: main operation (op)
	------------------------------------------------------------------------

	-- IP impl.op.wiring --- RBEGIN
	rng <= rng_sig;

	rst <= rst_sig;

	pwdn <= pwdn_sig;

	ackInvSetRng <= ackInvSetRng_sig;
	ackInvSetFocus <= ackInvSetFocus_sig;
	ackInvSetTexp <= ackInvSetTexp_sig;
	ackInvSetReg <= ackInvSetReg_sig;
	ackInvGetReg <= ackInvGetReg_sig;

	getRegVal <= regVal;

	ackInvModReg <= ackInvModReg_sig;

	enParrom <= '1' when stateOp=stateOpLoadA else '0';
	
	aParrom_vec <= std_logic_vector(to_unsigned(aParrom, 11));

	reqI2c <= '1' when stateOp=stateOpXfer else '0';

	stateOp_dbg <= x"00" when stateOp=stateOpInit
				else x"10" when stateOp=stateOpPwupA
				else x"11" when stateOp=stateOpPwupB
				else x"12" when stateOp=stateOpPwupC
				else x"13" when stateOp=stateOpPwupD
				else x"20" when stateOp=stateOpLoadA
				else x"21" when stateOp=stateOpLoadB
				else x"30" when stateOp=stateOpXfer
				else x"40" when stateOp=stateOpStep
				else x"50" when stateOp=stateOpInv
				else (others => '1');
	-- IP impl.op.wiring --- REND

	-- IP impl.op.rising --- BEGIN
	process (reset, mclk, stateOp)
		-- IP impl.op.vars --- RBEGIN
		constant regFocusMsb: std_logic_vector(15 downto 0) := x"3603";
		constant regFocusLsb: std_logic_vector(15 downto 0) := x"3602";

		constant regTexpMsb: std_logic_vector(15 downto 0) := x"350C";
		constant regTexpLsb: std_logic_vector(15 downto 0) := x"350D";

		constant a0ParromSpec: natural := 1024;

		variable regaddrLsb: std_logic_vector(15 downto 0);
		variable lsb: std_logic_vector(7 downto 0);

		variable cmdNotPrep: std_logic;
		variable specNotGnr: std_logic; -- prep: general vs. 5MP, cmd: focus/Texp vs. set/get/mod 

		variable modNotGetSet: std_logic;

		variable msbNotLsb: std_logic;

		variable bytecnt: natural range 0 to 4;

		constant imax: natural := 10; -- 1ms power up to reset high
		variable i: natural range 0 to imax;
		
		constant jmax: natural := 200; -- 20ms reset high to parrom initialization
		variable j: natural range 0 to jmax;
		
		constant kmax: natural := 2; -- parrom load
		variable k: natural range 0 to kmax;
		-- IP impl.op.vars --- REND

	begin
		if reset='1' then
			-- IP impl.op.asyncrst --- RBEGIN
			stateOp <= stateOpInit;

			rng_sig <= '0';
			rst_sig <= '0';
			pwdn_sig <= '1';
			ackInvSetRng_sig <= '0';
			ackInvSetFocus_sig <= '0';
			ackInvSetTexp_sig <= '0';
			ackInvSetReg_sig <= '0';
			ackInvGetReg_sig <= '0';
			regVal <= (others => '0');
			ackInvModReg_sig <= '0';
			i2cReadNotWrite <= '0';
			i2cRegaddr <= (others => '0');
			i2cSend <= (others => '0');
			aParrom <= 0;

			cmdNotPrep := '0';
			-- IP impl.op.asyncrst --- REND

		elsif rising_edge(mclk) then
			if stateOp=stateOpInit then
				-- IP impl.op.syncrst --- RBEGIN
				ackInvSetRng_sig <= '0';
				ackInvSetFocus_sig <= '0';
				ackInvSetTexp_sig <= '0';
				ackInvSetReg_sig <= '0';
				ackInvGetReg_sig <= '0';
				regVal <= (others => '0');
				ackInvModReg_sig <= '0';
				aParrom <= 0;
				-- IP impl.op.syncrst --- REND

				if cmdNotPrep='0' then
					-- IP impl.op.init.prep --- IBEGIN
					pwdn_sig <= '0';

					i := 0;
					-- IP impl.op.init.prep --- IEND

					stateOp <= stateOpPwupB;

				elsif reqInvSetFocus='1' then
					-- IP impl.op.init.invSetFocus --- IBEGIN
					specNotGnr := '1';
					msbNotLsb := '1';

					i2cReadNotWrite <= '0';
					i2cRegaddr <= regFocusMsb;
					i2cSend <= "00" & setFocusVcm(9 downto 4);

					regaddrLsb := regFocusLsb;
					lsb := setFocusVcm(3 downto 0) & "0000";
					-- IP impl.op.init.invSetFocus --- IEND

					stateOp <= stateOpXfer;

				elsif reqInvSetTexp='1' then
					-- IP impl.op.init.invSetTexp --- IBEGIN
					specNotGnr := '1';
					msbNotLsb := '1';

					i2cReadNotWrite <= '0';
					i2cRegaddr <= regTexpMsb;
					i2cSend <= "00" & setTexpTexp(13 downto 8);

					regaddrLsb := regTexpLsb;
					lsb := setTexpTexp(7 downto 0);
					-- IP impl.op.init.invSetTexp --- IEND

					stateOp <= stateOpXfer;

				elsif reqInvSetReg='1' then
					-- IP impl.op.init.invSetReg --- IBEGIN
					modNotGetSet := '0';
					specNotGnr := '0';
					msbNotLsb := '0';
					
					i2cReadNotWrite <= '0';
					i2cRegaddr <= setRegAddr;
					i2cSend <= setRegVal;
					-- IP impl.op.init.invSetReg --- IEND

					stateOp <= stateOpXfer;

				elsif reqInvGetReg='1' then
					-- IP impl.op.init.invGetReg --- IBEGIN
					modNotGetSet := '0';
					msbNotLsb := '0';

					i2cReadNotWrite <= '1';
					i2cRegaddr <= getRegAddr;
					-- IP impl.op.init.invGetReg --- IEND

					stateOp <= stateOpXfer;

				elsif reqInvModReg='1' then
					-- IP impl.op.init.invModReg --- IBEGIN
					modNotGetSet := '1';
					specNotGnr := '0';
					msbNotLsb := '0';

					i2cReadNotWrite <= '1';
					i2cRegaddr <= modRegAddr;
					-- IP impl.op.init.invModReg --- IEND

					stateOp <= stateOpXfer;
				end if;

			elsif stateOp=stateOpPwupA then
				if tkclk='1' then
					if i=imax then
						-- IP impl.op.pwupA.done --- IBEGIN
						rst_sig <= '1';

						j := 0;
						-- IP impl.op.pwupA.done --- IEND

						stateOp <= stateOpPwupD;

					else
						stateOp <= stateOpPwupB;
					end if;
				end if;

			elsif stateOp=stateOpPwupB then
				if tkclk='0' then
					i := i + 1; -- IP impl.op.pwupB.inc --- ILINE

					stateOp <= stateOpPwupA;
				end if;

			elsif stateOp=stateOpPwupC then
				if tkclk='1' then
					if j=jmax then
						-- IP impl.op.pwupC.done --- IBEGIN
						specNotGnr := '0';
						msbNotLsb := '0';
	
						i2cReadNotWrite <= '0';
	
						aParrom <= 0;
	
						bytecnt := 0;
						
						k := 0;
						-- IP impl.op.pwupC.done --- IEND

						stateOp <= stateOpLoadA;

					else
						stateOp <= stateOpPwupD;
					end if;
				end if;

			elsif stateOp=stateOpPwupD then
				if tkclk='0' then
					j := j + 1; -- IP impl.op.pwupD.inc --- ILINE

					stateOp <= stateOpPwupC;
				end if;

			elsif stateOp=stateOpLoadA then
				k := k + 1; -- IP impl.op.loadA.ext --- ILINE

				if k=kmax then
					stateOp <= stateOpLoadB;
				end if;

			elsif stateOp=stateOpLoadB then
				-- IP impl.op.loadB.ext --- IBEGIN
				bytecnt := bytecnt + 1;

				if bytecnt=4 then
					bytecnt := 0;
				end if;
				-- IP impl.op.loadB.ext --- IEND

				if (bytecnt=1 and drdParrom=x"00") then
					if specNotGnr='0' then
						-- IP impl.op.loadB.prepSpec --- IBEGIN
						aParrom <= a0ParromSpec;
						
						specNotGnr := '1';

						bytecnt := 0;
						
						k := 0;
						-- IP impl.op.loadB.prepSpec --- IEND

						stateOp <= stateOpLoadA;

					else
						-- IP impl.op.loadB.done --- IBEGIN
						rng_sig <= '1';

						cmdNotPrep := '1';
						-- IP impl.op.loadB.done --- IEND

						stateOp <= stateOpInit;
					end if;

				else
					aParrom <= aParrom + 1; -- IP impl.op.loadB.inc --- ILINE

					if bytecnt=0 then
						stateOp <= stateOpXfer;

					elsif bytecnt=1 then
						-- IP impl.op.loadB.addrmsb --- IBEGIN
						i2cRegaddr(15 downto 8) <= drdParrom;

						k := 0;
						-- IP impl.op.loadB.addrmsb --- IEND

						stateOp <= stateOpLoadA;

					elsif bytecnt=2 then
						-- IP impl.op.loadB.addrlsb --- IBEGIN
						i2cRegaddr(7 downto 0) <= drdParrom;

						k := 0;
						-- IP impl.op.loadB.addrlsb --- IEND

						stateOp <= stateOpLoadA;

					elsif bytecnt=3 then
						-- IP impl.op.loadB.val --- IBEGIN
						i2cSend <= drdParrom;

						k := 0;
						-- IP impl.op.loadB.val --- IEND

						stateOp <= stateOpLoadA;
					end if;
				end if;

			elsif stateOp=stateOpXfer then
				if dneI2c='1' then
					stateOp <= stateOpStep;
				end if;

			elsif stateOp=stateOpStep then
				if i2cReadNotWrite='0' then
					if cmdNotPrep='0' then
						-- IP impl.op.step.prep --- IBEGIN
						bytecnt := 0;

						k := 0;
						-- IP impl.op.step.prep --- IEND

						stateOp <= stateOpLoadA;

					else
						if msbNotLsb='0' then
							if specNotGnr='0' then
								-- IP impl.op.step.gnrDone --- IBEGIN
								if modNotGetSet='0' then
									ackInvSetReg_sig <= '1';
								else
									ackInvModReg_sig <= '1';
								end if;
								-- IP impl.op.step.gnrDone --- IEND

								stateOp <= stateOpInv;

							else
								-- IP impl.op.step.specDone --- IBEGIN
								if regaddrLsb=regFocusLsb then
									ackInvSetFocus_sig <= '1';
								else
									ackInvSetTexp_sig <= '1';
								end if;
								-- IP impl.op.step.specDone --- IEND

								stateOp <= stateOpInv;
							end if;

						else
							-- IP impl.op.step.lsb --- IBEGIN
							msbNotLsb := '0';

							i2cRegaddr <= regaddrLsb;
							i2cSend <= lsb;
							-- IP impl.op.step.lsb --- IEND

							stateOp <= stateOpXfer;
						end if;
					end if;

				else
					if modNotGetSet='0' then
						-- IP impl.op.step.get --- IBEGIN
						regVal <= i2cRecv;

						ackInvGetReg_sig <= '1';
						-- IP impl.op.step.get --- IEND

						stateOp <= stateOpInv;

					else
						-- IP impl.op.step.mod --- IBEGIN
						i2cReadNotWrite <= '0';
						i2cSend <= (i2cRecv and (not modRegMask)) or (modRegVal and modRegMask);
						-- IP impl.op.step.mod --- IEND

						stateOp <= stateOpXfer;
					end if;
				end if;

			elsif stateOp=stateOpInv then
				if ((reqInvSetRng='0' and ackInvSetRng_sig='1') or (reqInvSetFocus='0' and ackInvSetFocus_sig='1') or (reqInvSetTexp='0' and ackInvSetTexp_sig='1') or (reqInvSetReg='0' and ackInvSetReg_sig='1') or (reqInvGetReg='0' and ackInvGetReg_sig='1') or (reqInvModReg='0' and ackInvModReg_sig='1')) then
					stateOp <= stateOpInit;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.op.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end Camif;


