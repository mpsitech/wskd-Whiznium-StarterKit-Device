-- file Step.vhd
-- Step easy model controller implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 24 Dec 2021
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Cleb.all;

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
		step: out std_logic;
		nflt: in std_logic; -- iccl only

		stateOp_dbg: out std_logic_vector(7 downto 0)
	);
end Step;

architecture Step of Step is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	component BB is
		port (
			O: out std_logic;
			B: inout std_logic;
			I: in std_logic;
			T: in std_logic
		);
	end component;

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
	signal step_sig: std_logic;

	signal m0_sig: std_logic;
	signal m0z: std_logic;

	-- IP sigs.op.cust --- INSERT

	---- other
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myBbM0 : BB
		port map (
			O => open,
			B => m0,
			I => m0_sig,
			T => m0z
		);

	------------------------------------------------------------------------
	-- implementation: main operation (op)
	------------------------------------------------------------------------

	-- IP impl.op.wiring --- BEGIN
	getInfoAngle <= angle;

	ackInvMoveto <= ackInvMoveto_sig;
	ackInvSet <= ackInvSet_sig;
	ackInvZero <= ackInvZero_sig;

	nslp_sig <= '1' when rng='0' else '0';
	nslp <= nslp_sig;

	dir <= ccwNotCw;
	step <= step_sig;

	stateOp_dbg <= x"00" when stateOp=stateOpInit
				else x"10" when stateOp=stateOpReady
				else x"20" when stateOp=stateOpRunA
				else x"21" when stateOp=stateOpRunB
				else x"30" when stateOp=stateOpInv
				else (others => '1');
	-- IP impl.op.wiring --- END

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
			step_sig <= '0';
			m0_sig <= '0';
			m0z <= '0';
			-- IP impl.op.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateOp=stateOpInit or (stateOp/=stateOpInv and (reqInvMoveto='1' or reqInvSet='1' or reqInvZero='1'))) then
				-- IP impl.op.syncrst --- BEGIN
				angle <= 0;
				ackInvMoveto_sig <= '0';
				ackInvSet_sig <= '0';
				ackInvZero_sig <= '0';
				rng <= '0';
				ccwNotCw <= '0';
				step_sig <= '0';
				m0_sig <= '0';
				m0z <= '0';

				dAngle := 0;
				Tstep := 0;
				atTarget := false;
				-- IP impl.op.syncrst --- END

				if reqInvMoveto='1' then
					-- IP impl.op.init.moveto --- INSERT

					stateOp <= stateOpInv;

				elsif reqInvSet='1' then
					-- IP impl.op.init.set --- INSERT

					stateOp <= stateOpInv;

				elsif reqInvZero='1' then
					-- IP impl.op.init.zero --- INSERT

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
					-- IP impl.op.runA --- INSERT

					stateOp <= stateOpRunB;
				end if;

			elsif stateOp=stateOpRunB then
				if tkclk='0' then
					-- IP impl.op.runB --- INSERT

					if targetNotSteady and target=angle then
						-- IP impl.op.runB.done --- INSERT

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
