-- file Camif.vhd
-- Camif easy model controller implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Catherine Johnson (auto-generation)
-- date created: 1 Dec 2020
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Iccl.all;

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

		reqInvSetReg: in std_logic;
		ackInvSetReg: out std_logic;

		setRegAddr: in std_logic_vector(15 downto 0);
		setRegVal: in std_logic_vector(7 downto 0);

		reqInvSetRegaddr: in std_logic;
		ackInvSetRegaddr: out std_logic;

		setRegaddrAddr: in std_logic_vector(15 downto 0);

		reqInvGetReg: in std_logic;
		ackInvGetReg: out std_logic;

		getRegVal: out std_logic_vector(7 downto 0);

		reqInvModReg: in std_logic;
		ackInvModReg: out std_logic;

		modRegAddr: in std_logic_vector(15 downto 0);
		modRegMask: in std_logic_vector(7 downto 0);
		modRegVal: in std_logic_vector(7 downto 0);

		scl: out std_logic;
		sda: inout std_logic
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

	component Dpsram_size2kB_p8 is
		port (
			CLK: in std_logic;

			A_BLK_EN: in std_logic;
			A_WEN: in std_logic;

			A_ADDR: in std_logic_vector(10 downto 0);
			A_DOUT: out std_logic_vector(7 downto 0);
			A_DIN: in std_logic_vector(7 downto 0);

			B_BLK_EN: in std_logic;
			B_WEN: in std_logic;

			B_ADDR: in std_logic_vector(10 downto 0);
			B_DOUT: out std_logic_vector(7 downto 0);
			B_DIN: in std_logic_vector(7 downto 0)
		);
	end component;

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- camera master clock (camclk)

	-- IP sigs.camclk.cust --- INSERT

	---- main operation (op)
	type stateOp_t is (
		stateOpInit,
		stateOpPrepA, stateOpPrepB, stateOpPrepC, stateOpPrepD,
		stateOpLoadA, stateOpLoadB,
		stateOpXfer,
		stateOpStep,
		stateOpPwupdnA, stateOpPwupdnB,
		stateOpInv
	);
	signal stateOp: stateOp_t := stateOpInit;

	signal rng_sig: std_logic;
	signal ackInvSetRng_sig: std_logic;
	signal ackInvSetReg_sig: std_logic;
	signal ackInvSetRegaddr_sig: std_logic;
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

			devaddr => "01111000" -- 0x3C left-shifted by one
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

	myParrom : Dpsram_size2kB_p8
		port map (
			CLK => mclk,

			A_BLK_EN => enParrom,
			A_WEN => '0',

			A_ADDR => aParrom_vec,
			A_DOUT => drdParrom,
			A_DIN => (others => '0'),

			B_BLK_EN => '0',
			B_WEN => '0',

			B_ADDR => (others => '0'),
			B_DOUT => open,
			B_DIN => (others => '0')
		);

	------------------------------------------------------------------------
	-- implementation: camera master clock (camclk)
	------------------------------------------------------------------------

	-- IP impl.camclk.wiring --- BEGIN
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
	ackInvSetReg <= ackInvSetReg_sig;
	ackInvSetRegaddr <= ackInvSetRegaddr_sig;

	ackInvGetReg <= ackInvGetReg_sig;
	getRegVal <= regVal;

	ackInvModReg <= ackInvModReg_sig;

	enParrom <= '1' when stateOp=stateOpLoadA else '0';
	
	aParrom_vec <= std_logic_vector(to_unsigned(aParrom, 11));

	reqI2c <= '1' when stateOp=stateOpXfer else '0';

	stateOp_dbg <= x"00" when stateOp=stateOpInit
				else x"10" when stateOp=stateOpPrepA
				else x"11" when stateOp=stateOpPrepB
				else x"12" when stateOp=stateOpPrepC
				else x"13" when stateOp=stateOpPrepD
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
		constant a0ParromSpec: natural := 1024;

		variable prepdone: boolean;

		variable specNotGnr: boolean; -- during preparation: general vs. 5MP

		variable modNotGetSet: boolean;

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
			ackInvSetReg_sig <= '0';
			ackInvSetRegaddr_sig <= '0';
			ackInvGetReg_sig <= '0';
			regVal <= (others => '0');
			ackInvModReg_sig <= '0';

			i2cReadNotWrite <= '0';
			i2cRegaddr <= (others => '0');
			i2cSend <= (others => '0');

			aParrom <= 0;

			prepdone := false;
			-- IP impl.op.asyncrst --- REND

		elsif rising_edge(mclk) then
			if stateOp=stateOpInit then
				-- IP impl.op.syncrst --- RBEGIN
				ackInvSetRng_sig <= '0';
				ackInvSetReg_sig <= '0';
				ackInvSetRegaddr_sig <= '0';
				ackInvGetReg_sig <= '0';
				regVal <= (others => '0');
				ackInvModReg_sig <= '0';

				aParrom <= 0;
				-- IP impl.op.syncrst --- REND

				if not prepdone then
					-- IP impl.op.init.prep --- IBEGIN
					rst_sig <= '0';
					pwdn_sig <= '0';

					i := 0;
					-- IP impl.op.init.prep --- IEND

					stateOp <= stateOpPrepB;

				elsif reqInvSetRng='1' then
					if setRngRng=fls8 and !pwdn_sig then
						-- IP impl.op.init.pwdn --- IBEGIN
						rng_sig <= '0';
						pwdn_sig <= '1';

						j := 0;
						-- IP impl.op.init.pwdn --- IEND

						stateOp <= stateOpPwupdnB;

					elsif setRngRng=tru8 and pwdn_sig then
						-- IP impl.op.init.pwup --- IBEGIN
						pwdn_sig <= '0'; -- power up

						j := 0;
						-- IP impl.op.init.pwup --- IEND

						stateOp <= stateOpPwupdnB;

					else
						ackInvSetRng_sig <= '1'; -- IP impl.op.init.invSetRng --- ILINE

						stateOp <= stateOpInv;
					end if;

				elsif reqInvSetReg='1' then
					-- IP impl.op.init.invSetReg --- IBEGIN
					modNotGetSet := false;
					
					i2cReadNotWrite <= '0';
					i2cRegaddr <= setRegAddr;
					i2cSend <= setRegVal;
					-- IP impl.op.init.invSetReg --- IEND

					stateOp <= stateOpXfer;

				elsif reqInvSetRegaddr='1' then
					-- IP impl.op.init.invSetRegaddr --- IBEGIN
					i2cRegaddr <= setRegaddrAddr;

					ackInvSetRegaddr_sig <= '1';
					-- IP impl.op.init.invSetRegaddr --- IEND

					stateOp <= stateOpInv;

				elsif reqInvGetReg='1' then
					-- IP impl.op.init.invGetReg --- IBEGIN
					modNotGetSet := false;

					i2cReadNotWrite <= '1';
					-- IP impl.op.init.invGetReg --- IEND

					stateOp <= stateOpXfer;

				elsif reqInvModReg='1' then
					-- IP impl.op.init.invModReg --- IBEGIN
					modNotGetSet := true;

					i2cReadNotWrite <= '1';
					i2cRegaddr <= modRegAddr;
					-- IP impl.op.init.invModReg --- IEND

					stateOp <= stateOpXfer;
				end if;

			elsif stateOp=stateOpPrepA then
				if tkclk='1' then
					if i=imax then
						-- IP impl.op.prepA.done --- IBEGIN
						rst_sig <= '1';

						j := 0;
						-- IP impl.op.prepA.done --- IEND

						stateOp <= stateOpPrepD;

					else
						stateOp <= stateOpPrepB;
					end if;
				end if;

			elsif stateOp=stateOpPrepB then
				if tkclk='0' then
					i := i + 1; -- IP impl.op.prepB.inc --- ILINE

					stateOp <= stateOpPrepA;
				end if;

			elsif stateOp=stateOpPrepC then
				if tkclk='1' then
					if j=jmax then
						-- IP impl.op.prepC.done --- IBEGIN
						specNotGnr := false;
	
						i2cReadNotWrite <= '0';
	
						aParrom <= 0;
	
						bytecnt := 0;
						
						k := 0;
						-- IP impl.op.prepC.done --- IEND

						stateOp <= stateOpLoadA;

					else
						stateOp <= stateOpPrepD;
					end if;
				end if;

			elsif stateOp=stateOpPrepD then
				if tkclk='0' then
					j := j + 1; -- IP impl.op.prepD.inc --- ILINE

					stateOp <= stateOpPrepC;
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
					if not specNotGnr then
						-- IP impl.op.loadB.prepSpec --- IBEGIN
						aParrom <= a0ParromSpec;
						
						specNotGnr := true;

						bytecnt := 0;
						
						k := 0;
						-- IP impl.op.loadB.prepSpec --- IEND

						stateOp <= stateOpLoadA;

					else
						prepdone := true; -- IP impl.op.loadB.done --- ILINE

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
					if not prepdone then
						-- IP impl.op.step.prep --- IBEGIN
						bytecnt := 0;

						k := 0;
						-- IP impl.op.step.prep --- IEND

						stateOp <= stateOpLoadA;

					else
						-- IP impl.op.step.cmdDone --- IBEGIN
						if not modNotGetSet then
							ackInvSetReg_sig <= '1';
						else
							ackInvModReg_sig <= '1';
						end if;
						-- IP impl.op.step.cmdDone --- IEND

						stateOp <= stateOpInv;
					end if;

				else
					if not modNotGetSet then
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

			elsif stateOp=stateOpPwupdnA then
				if tkclk='1' then
					if j=jmax then
						-- IP impl.op.pwupdnA.done --- IBEGIN
						rng_sig <= not pwdn_sig;

						ackInvSetRng_sig <= '1';
						-- IP impl.op.pwupdnA.done --- IEND

						stateOp <= stateOpInv;

					else
						stateOp <= stateOpPwupdnB;
					end if;
				end if;

			elsif stateOp=stateOpPwupdnB then
				if tkclk='0' then
					j := j + 1; -- IP impl.op.pwupdnB.inc --- ILINE

					stateOp <= stateOpPwupdnA;
				end if;

			elsif stateOp=stateOpInv then
				if ((reqInvSetRng='0' and ackInvSetRng_sig='1') or (reqInvSetReg='0' and ackInvSetReg_sig='1') or (reqInvSetRegaddr='0' and ackInvSetRegaddr_sig='1') or (reqInvGetReg='0' and ackInvGetReg_sig='1') or (reqInvModReg='0' and ackInvModReg_sig='1')) then
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
