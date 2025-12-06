LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY adderSubtractor IS
  PORT(
    A, B          : IN  STD_LOGIC;
    CBin, control : IN  STD_LOGIC;
    res           : OUT STD_LOGIC;
    cbout         : OUT STD_LOGIC
  );
END ENTITY adderSubtractor;

ARCHITECTURE rtl OF adderSubtractor IS

BEGIN
  -- (control == 1) => adder
  -- (control == 0) => subtractor
  res   <= (A XOR B) XOR CBin;
  cbout <= (((A AND B) OR ((A XOR B) AND CBin)) AND control) OR ((((NOT A) AND B) OR ((NOT (A XOR B)) AND CBin)) AND (NOT control));

END ARCHITECTURE rtl;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FullAddSub IS
  GENERIC(n : INTEGER := 32);
  PORT(
    A, B          : IN  STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    CBin, control : IN  STD_LOGIC;
    res           : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    CBout         : OUT STD_LOGIC
  );
END ENTITY FullAddSub;

ARCHITECTURE rtl OF FullAddSub IS
  COMPONENT adderSubtractor IS
    PORT(
      A, B          : IN  STD_LOGIC;
      CBin, control : IN  STD_LOGIC;
      res           : OUT STD_LOGIC;
      CBout         : OUT STD_LOGIC
    );
  END COMPONENT adderSubtractor;
  SIGNAL carryVec : STD_LOGIC_VECTOR(n DOWNTO 0);
BEGIN
  -- (control == 1) => adder
  -- (control == 0) => subtractor
  carryVec(0) <= CBin;
  CBout       <= carryVec(n);
  rippleAddSub : FOR i IN 0 TO n - 1 GENERATE
    ux : adderSubtractor PORT MAP(A(i), B(i), carryVec(i), control, res(i), carryVec(i + 1));
  END GENERATE rippleAddSub;
END ARCHITECTURE rtl;
