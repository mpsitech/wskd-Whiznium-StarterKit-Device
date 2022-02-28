-- file Top.vhd
-- Top top_lttc_v1_0 top implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 24 Dec 2021
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Cleb.all;

entity Top is
	generic (
		fMclk: natural range 1 to 1000000 := 50000
	);
	port (
		extreset: in std_logic;

		extclkp: in std_logic;
		extclkn: in std_logic;

		dbg0: out std_logic;
		dbg1: out std_logic;
		btn0: in std_logic;
		btn1: in std_logic;
		rxd: in std_logic;
		txd: out std_logic;
		cs: out std_logic;
		sclk: out std_logic;
		mosi: out std_logic;
		led4_r: out std_logic;
		led4_g: out std_logic;
		led5_r: out std_logic;
		led5_g: out std_logic;
		nslp: out std_logic;
		m0: inout std_logic;
		dir: out std_logic;
		step: out std_logic;
		nflt: in std_logic
	);
end Top;

architecture Top of Top is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	component Bcdfreq_v1_0 is
		generic (
			fMclk: natural range 1 to 1000000 := 100000
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;

			high: in std_logic_vector(3 downto 0);
			low: in std_logic_vector(3 downto 0);

			freq: out std_logic
		);
	end component;

	component Debounce_v1_0 is
		generic (
			invert: boolean := false;
			tdead: natural range 1 to 10000 := 100
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: in std_logic;

			noisy: in std_logic;
			clean: out std_logic
		);
	end component;

	component Hostif is
		generic (
			fMclk: natural range 1 to 1000000 := 50000;
			fSclk: natural range 100 to 50000000 := 5000000
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: in std_logic;
			commok: out std_logic;
			reqReset: out std_logic;

			reqInvLaserSet: out std_logic;
			ackInvLaserSet: in std_logic;

			laserSetL: out std_logic_vector(15 downto 0);
			laserSetR: out std_logic_vector(15 downto 0);

			stateGetTixVClebState: in std_logic_vector(7 downto 0);

			stepGetInfoTixVState: in std_logic_vector(7 downto 0);
			stepGetInfoAngle: in std_logic_vector(15 downto 0);

			reqInvStepMoveto: out std_logic;
			ackInvStepMoveto: in std_logic;

			stepMovetoAngle: out std_logic_vector(15 downto 0);
			stepMovetoTstep: out std_logic_vector(7 downto 0);

			reqInvStepSet: out std_logic;
			ackInvStepSet: in std_logic;

			stepSetRng: out std_logic_vector(7 downto 0);
			stepSetCcwNotCw: out std_logic_vector(7 downto 0);
			stepSetTstep: out std_logic_vector(7 downto 0);

			reqInvStepZero: out std_logic;
			ackInvStepZero: in std_logic;

			tkclksrcGetTkstTkst: in std_logic_vector(31 downto 0);

			reqInvTkclksrcSetTkst: out std_logic;
			ackInvTkclksrcSetTkst: in std_logic;

			tkclksrcSetTkstTkst: out std_logic_vector(31 downto 0);

			rxd: in std_logic;
			txd: out std_logic
		);
	end component;

	component Laser is
		generic (
			fMclk: natural range 1 to 1000000
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;

			reqInvSet: in std_logic;
			ackInvSet: out std_logic;

			setL: in std_logic_vector(15 downto 0);
			setR: in std_logic_vector(15 downto 0);

			nss: out std_logic;
			sclk: out std_logic;
			mosi: out std_logic;

			stateOp_dbg: out std_logic_vector(7 downto 0)
		);
	end component;

	component Rgbled4 is
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: in std_logic;
			rgb: in std_logic_vector(23 downto 0);
			r: out std_logic;
			g: out std_logic;
			b: out std_logic;

			stateBlue_dbg: out std_logic_vector(7 downto 0);
			stateGreen_dbg: out std_logic_vector(7 downto 0);
			stateRed_dbg: out std_logic_vector(7 downto 0)
		);
	end component;

	component Rgbled5 is
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: in std_logic;
			rgb: in std_logic_vector(23 downto 0);
			r: out std_logic;
			g: out std_logic;
			b: out std_logic;

			stateBlue_dbg: out std_logic_vector(7 downto 0);
			stateGreen_dbg: out std_logic_vector(7 downto 0);
			stateRed_dbg: out std_logic_vector(7 downto 0)
		);
	end component;

	component State is
		port (
			reset: in std_logic;
			tkclk: in std_logic;

			commok: in std_logic;
			camrng: in std_logic;

			rgb: out std_logic_vector(23 downto 0);

			getTixVClebState: out std_logic_vector(7 downto 0);

			stateLed_dbg: out std_logic_vector(7 downto 0)
		);
	end component;

	component Step is
		generic (
			fMclk: natural range 1 to 1000000 := 50000
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
			nflt: in std_logic;

			stateOp_dbg: out std_logic_vector(7 downto 0)
		);
	end component;

	component Tkclksrc is
		generic (
			fMclk: natural range 1 to 1000000 := 50000
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: out std_logic;

			getTkstTkst: out std_logic_vector(31 downto 0);

			reqInvSetTkst: in std_logic;
			ackInvSetTkst: out std_logic;

			setTkstTkst: in std_logic_vector(31 downto 0)
		);
	end component;

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- reset (rst)
	type stateRst_t is (
		stateRstReset,
		stateRstRun
	);
	signal stateRst: stateRst_t := stateRstReset;

	signal reset: std_logic;

	-- IP sigs.rst.cust --- INSERT

	---- myDebounceBtn0
	signal btn0_sig: std_logic;

	---- myHostif
	signal commok: std_logic;

	signal laserSetL: std_logic_vector(15 downto 0);
	signal laserSetR: std_logic_vector(15 downto 0);

	signal stepMovetoAngle: std_logic_vector(15 downto 0);
	signal stepMovetoTstep: std_logic_vector(7 downto 0);

	signal stepSetRng: std_logic_vector(7 downto 0);
	signal stepSetCcwNotCw: std_logic_vector(7 downto 0);
	signal stepSetTstep: std_logic_vector(7 downto 0);

	signal tkclksrcSetTkstTkst: std_logic_vector(31 downto 0);

	---- myState
	signal rgb4: std_logic_vector(23 downto 0);

	signal stateGetTixVClebState: std_logic_vector(7 downto 0);

	---- myStep
	signal stepGetInfoTixVState: std_logic_vector(7 downto 0);
	signal stepGetInfoAngle: std_logic_vector(15 downto 0);

	---- myTkclksrc
	signal tkclk: std_logic;

	signal tkclksrcGetTkstTkst: std_logic_vector(31 downto 0);

	---- handshake
	-- myHostif to (many)
	signal reqResetFromHostif: std_logic;

	-- myHostif to myLaser
	signal reqInvLaserSet: std_logic;
	signal ackInvLaserSet: std_logic;

	-- myDebounceBtn1 to (many)
	signal reqResetBtn1: std_logic;

	-- myHostif to myStep
	signal reqInvStepMoveto: std_logic;
	signal ackInvStepMoveto: std_logic;

	-- myHostif to myStep
	signal reqInvStepSet: std_logic;
	signal ackInvStepSet: std_logic;

	-- myHostif to myStep
	signal reqInvStepZero: std_logic;
	signal ackInvStepZero: std_logic;

	-- myHostif to myTkclksrc
	signal reqInvTkclksrcSetTkst: std_logic;
	signal ackInvTkclksrcSetTkst: std_logic;

	---- other
	signal mclk: std_logic := '0';
	signal camrng: std_logic;
	signal rgb5: std_logic_vector(23 downto 0);

	signal bcddbg0: std_logic_vector(7 downto 0);
	signal bcddbg1: std_logic_vector(7 downto 0);
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myBcdfreqDbg0 : Bcdfreq_v1_0
		generic map (
			fMclk => fMclk
		)
		port map (
			reset => reset,
			mclk => mclk,

			high => bcddbg0(7 downto 4),
			low => bcddbg0(3 downto 0),

			freq => dbg0
		);

	myBcdfreqDbg1 : Bcdfreq_v1_0
		generic map (
			fMclk => fMclk
		)
		port map (
			reset => reset,
			mclk => mclk,

			high => bcddbg1(7 downto 4),
			low => bcddbg1(3 downto 0),

			freq => dbg1
		);

	myDebounceBtn0 : Debounce_v1_0
		generic map (
			invert => false,
			tdead => 100
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			noisy => btn0,
			clean => btn0_sig
		);

	myDebounceBtn1 : Debounce_v1_0
		generic map (
			invert => false,
			tdead => 100
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			noisy => btn1,
			clean => reqResetBtn1
		);

	myDebounceBtn2 : Debounce_v1_0
		generic map (
			invert => false,
			tdead => 100
		)
		port map (
			reset => open,
			mclk => open,
			tkclk => open,

			noisy => open,
			clean => open
		);

	myDebounceBtn3 : Debounce_v1_0
		generic map (
			invert => false,
			tdead => 100
		)
		port map (
			reset => open,
			mclk => open,
			tkclk => open,

			noisy => open,
			clean => open
		);

	myHostif : Hostif
		generic map (
			fMclk => 50000,
			fSclk => 5000000
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,
			commok => commok,
			reqReset => reqResetFromHostif,

			reqInvLaserSet => reqInvLaserSet,
			ackInvLaserSet => ackInvLaserSet,

			laserSetL => laserSetL,
			laserSetR => laserSetR,

			stateGetTixVClebState => stateGetTixVClebState,

			stepGetInfoTixVState => stepGetInfoTixVState,
			stepGetInfoAngle => stepGetInfoAngle,

			reqInvStepMoveto => reqInvStepMoveto,
			ackInvStepMoveto => ackInvStepMoveto,

			stepMovetoAngle => stepMovetoAngle,
			stepMovetoTstep => stepMovetoTstep,

			reqInvStepSet => reqInvStepSet,
			ackInvStepSet => ackInvStepSet,

			stepSetRng => stepSetRng,
			stepSetCcwNotCw => stepSetCcwNotCw,
			stepSetTstep => stepSetTstep,

			reqInvStepZero => reqInvStepZero,
			ackInvStepZero => ackInvStepZero,

			tkclksrcGetTkstTkst => tkclksrcGetTkstTkst,

			reqInvTkclksrcSetTkst => reqInvTkclksrcSetTkst,
			ackInvTkclksrcSetTkst => ackInvTkclksrcSetTkst,

			tkclksrcSetTkstTkst => tkclksrcSetTkstTkst,

			rxd => rxd,
			txd => txd
		);

	myLaser : Laser
		generic map (
			fMclk => fMclk
		)
		port map (
			reset => reset,
			mclk => mclk,

			reqInvSet => reqInvLaserSet,
			ackInvSet => ackInvLaserSet,

			setL => laserSetL,
			setR => laserSetR,

			nss => cs,
			sclk => sclk,
			mosi => mosi,

			stateOp_dbg => open
		);

	myRgbled4 : Rgbled4
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,
			rgb => rgb4,
			r => led4_r,
			g => led4_g,
			b => open,

			stateBlue_dbg => open,
			stateGreen_dbg => open,
			stateRed_dbg => open
		);

	myRgbled5 : Rgbled5
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,
			rgb => rgb5,
			r => led5_r,
			g => led5_g,
			b => open,

			stateBlue_dbg => open,
			stateGreen_dbg => open,
			stateRed_dbg => open
		);

	myState : State
		port map (
			reset => reset,
			tkclk => tkclk,

			commok => commok,
			camrng => camrng,

			rgb => rgb4,

			getTixVClebState => stateGetTixVClebState,

			stateLed_dbg => open
		);

	myStep : Step
		generic map (
			fMclk => fMclk -- in kHz
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			getInfoTixVState => stepGetInfoTixVState,
			getInfoAngle => stepGetInfoAngle,

			reqInvMoveto => reqInvStepMoveto,
			ackInvMoveto => ackInvStepMoveto,

			movetoAngle => stepMovetoAngle,
			movetoTstep => stepMovetoTstep,

			reqInvSet => reqInvStepSet,
			ackInvSet => ackInvStepSet,

			setRng => stepSetRng,
			setCcwNotCw => stepSetCcwNotCw,
			setTstep => stepSetTstep,

			reqInvZero => reqInvStepZero,
			ackInvZero => ackInvStepZero,

			nslp => nslp,
			m0 => m0,
			dir => dir,
			step => step,
			nflt => nflt, -- iccl only

			stateOp_dbg => open
		);

	myTkclksrc : Tkclksrc
		generic map (
			fMclk => fMclk
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			getTkstTkst => tkclksrcGetTkstTkst,

			reqInvSetTkst => reqInvTkclksrcSetTkst,
			ackInvSetTkst => ackInvTkclksrcSetTkst,

			setTkstTkst => tkclksrcSetTkstTkst
		);

	------------------------------------------------------------------------
	-- implementation: reset (rst)
	------------------------------------------------------------------------

	-- IP impl.rst.wiring --- BEGIN
	reset <= '1' when stateRst=stateRstReset else '0';
	-- IP impl.rst.wiring --- END

	-- IP impl.rst.rising --- BEGIN
	process (extreset, mclk, stateRst)
		-- IP impl.rst.vars --- BEGIN
		constant imax: natural := 16;
		variable i: natural range 0 to imax := 0;
		-- IP impl.rst.vars --- END

	begin
		if extreset='1' then
			stateRst <= stateRstReset;

			i := 0;

		elsif rising_edge(mclk) then
			if stateRst=stateRstReset then
				i := i + 1;

				if i=imax then
					stateRst <= stateRstRun;
				end if;

			elsif stateRst=stateRstRun then
				if reqResetFromHostif='1' or reqResetBtn1='1' then
					i := 0;
					stateRst <= stateRstReset;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.rst.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end Top;
