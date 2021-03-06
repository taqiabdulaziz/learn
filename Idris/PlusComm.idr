module PlusComm

%default total
%access export

public export
codata Conat : Type where
  Coz : Conat
  Cos : Conat -> Conat

public export
codata Bisimulation : Conat -> Conat -> Type where
  Biz : Bisimulation Coz Coz
  Bis : {a : Conat} -> {b : Conat} ->
        (Bisimulation a b) ->
        (Bisimulation (Cos a) (Cos b))

MuGen : Conat
MuGen = Cos MuGen

muGenSucc : Bisimulation (Cos MuGen) MuGen
muGenSucc = Bis muGenSucc

public export
Add : Conat -> Conat -> Conat
Add Coz b = b
Add (Cos a) b = Cos $ Add b a

reflx : (b : Conat) -> Bisimulation b b
reflx Coz = Biz
reflx (Cos n) = Bis $ reflx n

trans : Bisimulation a b -> Bisimulation b c -> Bisimulation a c
trans Biz Biz = Biz
trans (Bis a) (Bis b) = Bis $ trans a b

symm : Bisimulation a b -> Bisimulation b a
symm Biz = Biz
symm (Bis a) = Bis $ symm a

-- addN : (n : Conat) -> Bisimulation a b -> Bisimulation (Add a n) (Add b n)
-- addN Coz Biz = Biz
-- addN Coz (Bis x) = Bis x
-- addN (Cos x) Biz = Bis (reflx x)
-- addN (Cos x) (Bis y) = Bis (Bis (addN x y))

addN : Bisimulation (Add a b) (Add b a) -> Bisimulation (Add (Cos a) b) (Add (Cos b) a)
addN b = Bis (symm b)

toInductive : Conat -> Nat
toInductive Coz = Z
toInductive (Cos x) = S $ toInductive x

plusCommutative : (a : Conat) -> (b : Conat) ->
                  Bisimulation (Add a b) (Add b a)
plusCommutative Coz Coz = Biz
plusCommutative Coz (Cos x) = Bis (reflx x)
plusCommutative (Cos x) Coz = Bis (reflx x)
plusCommutative (Cos x) (Cos y) = Bis (addN $ plusCommutative y x)
