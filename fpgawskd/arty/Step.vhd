-- file Step.vhd
-- Step easy model controller implementation
-- author Catherine Johnson
-- date created: 17 Oct 2020
-- date modified: 17 Oct 2020

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

		step1: out std_logic;
		step2: out std_logic;
		step3: out std_logic;
		step4: out std_logic;

		stateOp_dbg: out std_logic_vector(7 downto 0)
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

	signal step1_sig: std_logic;
	signal step2_sig: std_logic;
	signal step3_sig: std_logic;
	signal step4_sig: std_logic;

	-- IP sigs.op.cust --- INSERT

	---- other
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	-- implementation: main operation (op)
	------------------------------------------------------------------------

	-- IP impl.op.wiring --- RBEGIN
	getInfoTixVState <= tixVStateMove when stateOp=stateOpRunA or stateOp=stateOpRunB else tixVStateIdle;

	getInfoAngle <= angle_vec;
	angle_vec <= std_logic_vector(to_unsigned(angle, 16));

	ackInvMoveto <= ackInvMoveto_sig;
	ackInvSet <= ackInvSet_sig;
	ackInvZero <= ackInvZero_sig;

	step1 <= step1_sig;
	step2 <= step2_sig;
	step3 <= step3_sig;
	step4 <= step4_sig;
	-- IP impl.op.wiring --- REND

	-- IP impl.op.rising --- BEGIN
	process (reset, mclk, stateOp)
		-- IP impl.op.vars --- RBEGIN
		variable i: natural range 0 to 255;

		constant seqmax: natural := 7;
		type seq_t is array (0 to seqmax) of std_logic_vector(3 downto 0);
		--constant seq: seq_t := ("1000", "1100", "0100", "0110", "0010", "0011", "0001", "1001");
		constant seq: seq_t := ("1100", "1100", "0110", "0110", "0011", "0011", "1001", "1001");

		variable iseq: natural range 0 to seqmax;

		variable target: natural range 0 to 4095;
		variable dAngle: integer range -4095 to 4096;

		variable rng: boolean;
		variable ccwNotCw: boolean;

		variable Tstep: natural range 0 to 255;

		variable targetNotSteady: boolean;
		variable atTarget: boolean;
		-- IP impl.op.vars --- REND

	begin
		if reset='1' then
			-- IP impl.op.asyncrst --- RBEGIN
			stateOp <= stateOpInit;

			angle <= 0;

			ackInvMoveto_sig <= '0';
			ackInvSet_sig <= '0';
			ackInvZero_sig <= '0';

			step1_sig <= '1';
			step2_sig <= '1';
			step3_sig <= '1';
			step4_sig <= '1';

			i := 0;
			iseq := 0;

			target := 0;
			dAngle := 0;

			rng := false;
			ccwNotCw := false;

			Tstep := 150;

			targetNotSteady := false;
			atTarget := false;
			-- IP impl.op.asyncrst --- REND

		elsif rising_edge(mclk) then
			if (stateOp=stateOpInit or (stateOp/=stateOpInv and (reqInvMoveto='1' or reqInvSet='1' or reqInvZero='1'))) then
				-- IP impl.op.syncrst --- RBEGIN
				ackInvMoveto_sig <= '0';
				ackInvSet_sig <= '0';
				ackInvZero_sig <= '0';
				step1_sig <= '1';
				step2_sig <= '1';
				step3_sig <= '1';
				step4_sig <= '1';

				-- IP impl.op.syncrst --- REND

				if reqInvMoveto='1' then
					-- IP impl.op.init.moveto --- IBEGIN
					targetNotSteady := true;

					-- determine shortest path
					target := to_integer(unsigned(movetoAngle));
					dAngle := target - angle;

					atTarget := (dAngle = 0);

					if not atTarget then
						if dAngle > 2048 then
							-- dAngle := dAngle - 4096; -- will become negative
							ccwNotCw := true;
						elsif dAngle < -2047 then
							--dAngle := dAngle + 4096; -- will become positive
							ccwNotCw := false;
						elsif dAngle > 0 then
							ccwNotCw := false;
						else
							ccwNotCw := true;
						end if;
					end if;

					Tstep := to_integer(unsigned(movetoTstep));

					ackInvMoveto_sig <= '1';
					-- IP impl.op.init.moveto --- IEND

					stateOp <= stateOpInv;

				elsif reqInvSet='1' then
					-- IP impl.op.init.set --- IBEGIN
					targetNotSteady := false;

					rng := (setRng = tru8);
					ccwNotCw := (setCcwNotCw = tru8);
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
						i := 0; -- IP impl.op.ready.steady --- ILINE

						stateOp <= stateOpRunB;

					elsif targetNotSteady and not atTarget then
						i := 0; -- IP impl.op.ready.target --- ILINE

						stateOp <= stateOpRunB;
					end if;
				end if;

			elsif stateOp=stateOpRunA then
				if tkclk='1' then
					-- IP impl.op.runA --- IBEGIN
					if i=Tstep then
						i := 0;
	
						if not ccwNotCw then
							if iseq=0 then
								iseq := seqmax;
							else
								iseq := iseq - 1;
							end if;
		
							if angle=4095 then
								angle <= 0;
							else
								angle <= angle + 1;
							end if;
		
						else
							if iseq=seqmax then
								iseq := 0;
							else
								iseq := iseq + 1;
							end if;

							if angle=0 then
								angle <= 4095;
							else
								angle <= angle - 1;
							end if;
						end if; 
		
						step1_sig <= seq(iseq)(3);
						step2_sig <= seq(iseq)(2);
						step3_sig <= seq(iseq)(1);
						step4_sig <= seq(iseq)(0);
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


