-- file Step.vhd
-- Step easy model controller implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Catherine Johnson (auto-generation)
-- date created: 1 Dec 2020
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

use work.Dbecore.all;
use work.Arty.all;

entity Step is
	generic (
		fMclk: natural range 1 to 1000000 := 50000 -- in kHz
	);
	port (
		reset: in std_logic;
		mclk: in std_logic;
		tkclk: in std_logic;

		getInfoTixVState: out std_logic_vector(7 downto 0);
		getInfoAngle: out std_logic_vector(15 downto 0);

		reqInvMoveto: in std_logic;
		ackInvMoveto: out std_logic;

		movetoAngle: in std_logic_vector(15 downto 0);
		movetoTstep: in std_logic_vector(7 downto 0);

		reqInvSet: in std_logic;
		ackInvSet: out std_logic;

		setRng: in std_logic_vector(7 downto 0);
		setCcwNotCw: in std_logic_vector(7 downto 0);
		setTstep: in std_logic_vector(7 downto 0);

		reqInvZero: in std_logic;
		ackInvZero: out std_logic;

		nslp: out std_logic;
		m0: inout std_logic;
		dir: out std_logic;
		step0: out std_logic
	);
end Step;

architecture Step of Step is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	constant tixVStateIdle: std_logic_vector(7 downto 0) := x"00";
	constant tixVStateMove: std_logic_vector(7 downto 0) := x"01";

	---- main operation (op)
	type stateOp_t is (
		stateOpInit,
		stateOpReady,
		stateOpRunA, stateOpRunB,
		stateOpInv
	);
	signal stateOp: stateOp_t := stateOpInit;

	signal angle: natural range 0 to 4095;
	signal angle_vec: std_logic_vector(15 downto 0);

	signal ackInvMoveto_sig: std_logic;
	signal ackInvSet_sig: std_logic;
	signal ackInvZero_sig: std_logic;

	signal rng: std_logic;
	signal nslp_sig: std_logic;

	signal ccwNotCw: std_logic;
	signal step0_sig: std_logic;

	signal m0_sig: std_logic;
	signal m0z: std_logic;

	-- IP sigs.op.cust --- INSERT

	---- other
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myIobufM0 : IOBUF
		port map (
			O => open,
			IO => m0,
			I => m0_sig,
			T => m0z
		);

	------------------------------------------------------------------------
	-- implementation: main operation (op)
	------------------------------------------------------------------------

	-- IP impl.op.wiring --- RBEGIN
	angle_vec <= std_logic_vector(to_unsigned(angle, 16));
	getInfoAngle <= angle_vec;

	ackInvMoveto <= ackInvMoveto_sig;
	ackInvSet <= ackInvSet_sig;
	ackInvZero <= ackInvZero_sig;

	nslp <= '1';

	dir <= ccwNotCw;
	step0 <= step_sig;

	stateOp_dbg <= x"00" when stateOp=stateOpInit
				else x"10" when stateOp=stateOpReady
				else x"20" when stateOp=stateOpRunA
				else x"21" when stateOp=stateOpRunB
				else x"30" when stateOp=stateOpInv
				else (others => '1');
	-- IP impl.op.wiring --- REND

	-- IP impl.op.rising --- BEGIN
	process (reset, mclk, stateOp)
		-- IP impl.op.vars --- BEGIN
		constant target: natural range 0 to 1000 := 0;
		variable dAngle: integer range -999 to 1000 := 0;

		variable Tstep: natural range 0 to 255 := 0;

		constant targetNotSteady: boolean := false;
		variable atTarget: boolean := false;
		-- IP impl.op.vars --- END

	begin
		if reset='1' then
			-- IP impl.op.asyncrst --- BEGIN
			stateOp <= stateOpInit;
			angle <= 0;
			ackInvMoveto_sig <= '0';
			ackInvSet_sig <= '0';
			ackInvZero_sig <= '0';
			rng <= '0';
			ccwNotCw <= '0';
			step0_sig <= '0';
			m0_sig <= '0';
			m0z <= '0';
			-- IP impl.op.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateOp=stateOpInit or (stateOp/=stateOpInv and (reqInvMoveto='1' or reqInvSet='1' or reqInvZero='1'))) then
				-- IP impl.op.syncrst --- RBEGIN
				ackInvMoveto_sig <= '0';
				ackInvSet_sig <= '0';
				ackInvZero_sig <= '0';
				step_sig <= '0';
				m0_sig <= '0';
				m0z <= '0';

				dAngle := 0;
				-- IP impl.op.syncrst --- REND

				if reqInvMoveto='1' then
					-- IP impl.op.init.moveto --- IBEGIN
					targetNotSteady := true;

					-- determine shortest path
					target := to_integer(unsigned(movetoAngle));
					dAngle := target - angle;

					atTarget := (dAngle = 0);

					if not atTarget then
						if dAngle > 500 then
							-- dAngle := dAngle - 1000; -- will become negative
							ccwNotCw <= '1';
						elsif dAngle < -499 then
							--dAngle := dAngle + 1000; -- will become positive
							ccwNotCw <= '0';
						elsif dAngle > 0 then
							ccwNotCw <= '0';
						else
							ccwNotCw <= '1';
						end if;
					end if;

					Tstep := to_integer(unsigned(movetoTstep));

					ackInvMoveto_sig <= '1';
					-- IP impl.op.init.moveto --- IEND

					stateOp <= stateOpInv;

				elsif reqInvSet='1' then
					-- IP impl.op.init.set --- IBEGIN
					targetNotSteady := false;
					atTarget := (setRng /= tru8);

					if setCcwNotCw=tru8 then
						ccwNotCw <= '1';
					else
						ccwNotCw <= '0';
					end if;
					Tstep := to_integer(unsigned(setTstep));

					ackInvSet_sig <= '1';
					-- IP impl.op.init.set --- IEND

					stateOp <= stateOpInv;

				elsif reqInvZero='1' then
					-- IP impl.op.init.zero --- IBEGIN
					angle <= 0;
					
					ackInvZero_sig <= '1';
					-- IP impl.op.init.zero --- IEND

					stateOp <= stateOpInv;

				else
					stateOp <= stateOpReady;
				end if;

			elsif stateOp=stateOpReady then
				if Tstep/=0 then
					if not targetNotSteady and rng then
						-- IP impl.op.ready.steady --- INSERT

						stateOp <= stateOpRunB;

					elsif targetNotSteady and not atTarget then
						-- IP impl.op.ready.target --- INSERT

						stateOp <= stateOpRunB;

					else
						-- IP impl.op.ready.hold --- INSERT

						stateOp <= stateOpReady;
					end if;
				end if;

			elsif stateOp=stateOpRunA then
				if tkclk='1' then
					-- IP impl.op.runA --- IBEGIN
					if i=Tstep then
						i := 0;
						
						if ccwNotCw='0' then
							if angle=999 then
								angle <= 0;
							else
								angle <= angle + 1;
							end if;
						else
							if angle=0 then
								angle <= 999;
							else
								angle <= angle - 1;
							end if;
						end if;
						
						step_sig <= not step_sig;
					end if;
					-- IP impl.op.runA --- IEND

					stateOp <= stateOpRunB;
				end if;

			elsif stateOp=stateOpRunB then
				if tkclk='0' then
					i := i + 1; -- IP impl.op.runB --- ILINE

					if targetNotSteady and target=angle then
						atTarget := true; -- IP impl.op.runB.done --- ILINE

						stateOp <= stateOpReady;

					else
						stateOp <= stateOpRunA;
					end if;
				end if;

			elsif stateOp=stateOpInv then
				if ((reqInvMoveto='0' and ackInvMoveto_sig='1') or (reqInvSet='0' and ackInvSet_sig='1') or (reqInvZero='0' and ackInvZero_sig='1')) then
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

end Step;
