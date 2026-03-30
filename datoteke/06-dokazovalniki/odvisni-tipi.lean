#eval "Hello, world!"

def podvoji : Int -> Int := fun x => 2 * x

def sestej : List Int -> Int :=
    fun xs =>
        match xs with
        | [] => 0
        | x :: xs' => x + sestej xs'

--  če bi pisali x + sestej xs, se Lean pritoži, da se funkcija
--  ne ustavi, kar reši našo 1. težavo

#eval sestej [1, 2, 3]

def sestej' : List Int -> Int
    | [] => 0
    | x :: xs => x + sestej' xs

inductive Naravno : Type where
| Nic : Naravno
| Naslednik : Naravno -> Naravno

def plus : Naravno -> Naravno -> Naravno
| Naravno.Nic, n => n
| Naravno.Naslednik m, n => Naravno.Naslednik (plus m n)

inductive Seznam : Type where
| Prazen : Seznam
| Sestavljen : String -> Seznam -> Seznam

inductive Vektor : Naravno -> Type where
| Prazen : Vektor Naravno.Nic
| Sestavljen : String -> Vektor n -> Vektor (Naravno.Naslednik n)

def stakni : Vektor m -> Vektor n -> Vektor (plus m n)
| .Prazen, ys => ys
| .Sestavljen x xs, ys => .Sestavljen x (stakni xs ys)

-- Opomba: .Sestavljen x (stakni ys xs) ne dela, ker
-- Lean še ne ve, da je plus komutativen

-- Zapišimo induktivno relacijo m ≤ n:
--                 m ≤ n
-- ---------    -----------
--   0 ≤ m        m+ ≤ n+
-- -

inductive ManjsiEnak : Naravno -> Naravno -> Type where
| NicManjsiOdVseh : (m : Naravno) -> ManjsiEnak Naravno.Nic m
| NaslednikManjsi :
    ManjsiEnak m n ->
    ManjsiEnak (Naravno.Naslednik m) (Naravno.Naslednik n)

-- Rešili smo 2. težavo, kako predstaviti predikate.

def refleksivnost : (m : Naravno) -> ManjsiEnak m m
| Naravno.Nic => ManjsiEnak.NicManjsiOdVseh Naravno.Nic
| Naravno.Naslednik m => ManjsiEnak.NaslednikManjsi (refleksivnost m)

-- 3. težavo rešimo tako, da namesto Type izberemo Prop

inductive ManjsiEnakIzjava : Naravno -> Naravno -> Prop where
| NicManjsiOdVseh : (m : Naravno) -> ManjsiEnakIzjava Naravno.Nic m
| NaslednikManjsi :
    ManjsiEnakIzjava m n ->
    ManjsiEnakIzjava (Naravno.Naslednik m) (Naravno.Naslednik n)

def refleksivnostIzjava : (m : Naravno) -> ManjsiEnakIzjava m m
| Naravno.Nic => ManjsiEnakIzjava.NicManjsiOdVseh Naravno.Nic
| Naravno.Naslednik m => ManjsiEnakIzjava.NaslednikManjsi (refleksivnostIzjava m)

-- Rešimo še 0. problem

def refleksivnostPrekTaktik : (m : Naravno) -> ManjsiEnakIzjava m m :=
    by
        intro m
        induction m
        · apply ManjsiEnakIzjava.NicManjsiOdVseh
        · apply ManjsiEnakIzjava.NaslednikManjsi
          assumption
