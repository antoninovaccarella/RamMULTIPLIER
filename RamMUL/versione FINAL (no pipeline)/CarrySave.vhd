library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CarrySave is
    generic (nb:integer);
    Port (  A : in STD_LOGIC_VECTOR(nb-1 downto 0); --ingresso A
            B : in STD_LOGIC_VECTOR(nb-1 downto 0); --ingresso B
            C : in STD_LOGIC_VECTOR(nb-1 downto 0); --ingresso C
            SP : out STD_LOGIC_VECTOR(nb-1 downto 0); --somma SP tra A, B e C
            VR : out STD_LOGIC_VECTOR(nb-1 downto 0)); --vettore di riporto
end CarrySave;

architecture Behavioral of CarrySave is

signal tsp, tvr : STD_LOGIC_VECTOR(nb-1 downto 0);

begin
--STEP 1

GEN_FA:
    for i in 0 to (nb-1) generate  --for generate
    --FULL ADDER
        tsp(i) <= A(i) XOR B(i) XOR C(i);
        tvr(i) <= (A(i) AND B(i)) OR (A(i) AND C(i)) OR (B(i) AND C(i));
    end generate GEN_FA;

--STEP 2                
SP<= tsp;
VR<= (tvr(nb-2 downto 0))&'0';
        
end Behavioral;