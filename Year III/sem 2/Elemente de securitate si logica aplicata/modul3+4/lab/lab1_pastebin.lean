-- Lean - limbaj pentru programarea functionala
--      - prover assistant

-- seamana mult cu Haskell


-- avem doua comenzi principale (sunt 3)

-- evaluarea rezultatelor, functiilor
-- comanda #eval

#eval 1 + 1
#eval 7 * 5 + 12
#eval "hello" ++ " world"

-- constructia demonstratiilor
-- comanda #check

#check 1
#check -1
#check "hello world"
#check Nat
#check Bool -> Nat
#check Type 10

-- definirea functiilor

-- Sa se defineasca o functie care primeste un numar natural
-- si returneaza numarul respectiv + 5

-- def <function_name> ([<var> : <type_var>]) : <return_type> := <body>
def plus5 (n : Nat) : Nat := n + 5
#check plus5
#eval plus5 10

def plus5' (n : Nat) := n + 5
#check plus5'

def plus5'' (n) := n + 5
#check plus5''

def plus5''' : Nat -> Nat := fun n => n + 5
#check @plus5'''
#check plus5'''

def plus5'''' := fun n => n + 5
#check plus5''''

#eval plus5'''' 10 == plus5'' 10

-- Sa se defineasca o functie cu numele `applyFunction` care sa primeasca
-- un argument de un tip α
-- o functie de la α la β
-- returneaza un β

def applyFunction (α β : Type) (a : α) (f : α → β) : β := f a

#check applyFunction
#eval applyFunction Nat Bool 2 (fun x => x > 2)

def applyFunction' {α β : Type} (a : α) (f : α → β) : β := f a
#check applyFunction'
#check applyFunction' 2
#eval applyFunction' 2 (fun x => x == 2)

-- currying si uncurrying
def f : Nat → Nat → Nat := fun x y => x + y
#check @f
#check @f 2
#check @f 2 3

#eval f 2 3

-- avem functiile map, filter, fold

#check @List.map
#eval List.map (fun x => x == 2) [1, 2, 3, 4]

#check @List.filter
#eval List.filter (fun x => x < 5) [1, 2, 5, 8, 9]

-- putem defini structuri

structure Student where
  name : String
  group : Nat

#check Student.mk

def me : Student := Student.mk "Nume" 100
def me' : Student := { name := "Nume", group := 100 }

def studentToString (s : Student) : String :=
  s.name ++ " " ++ (toString s.group)

#eval studentToString me'

namespace Hidden
  structure Option (α : Type)  where
    some : α → Option α
    none : Option α

end Hidden

#check Option

def sub? : Nat → Nat → Option Nat :=
  fun x y =>
  if x < y then none else some (x - y)

#eval sub? 10 2

-- construim numerele naturale utilizand axiomatica lui Peano

-- construim multimea ℕ ca fiind (ℕ, 0, succ)
-- astfel incat 0 si succ sa fie cei doi constructori ai lui ℕ
-- 0 : ℕ si succ : ℕ → ℕ

inductive Natural
| zero : Natural
| succ : Natural → Natural

#check @Natural.succ
#reduce Natural.succ $ Natural.succ $ Natural.zero

-- definim adunarea

-- Natural fiind un tip de date inductiv, functiile se implementeaza
-- pe constructorii tipului de date

@[simp]
def Natural.add : Natural → Natural → Natural :=
  fun x y =>
  match x with
  | zero => y
  | succ x' => succ $ Natural.add x' y

#check Natural.add._eq_1
#check Natural.add._eq_2

-- stim
-- (P1) (∀ y ∈ ℕ), 0 + y = y
-- (P2) (∀ x' y ∈ ℕ), succ x' + y = succ (x' + y)
-- (axiome ale adunarii)

-- vrem sa demonstram si ca ∀ y ∈ ℕ, y + 0 = y

-- cum demonstram?

-- vrem sa demonstram n_plus_0_eq_n(n): n + 0 = n
-- cum demonstram aceasta proprietate?

-- evident, prin inductie
-- orice propozitie peste un tip de date inductiv se demonstreaza prin inductie

-- ∀ n, n + 0 = n
-- pasul 0: 0 + 0 = 0 -> evident din (P1) cu y = 0
-- stim n + 0 = n (ipoteza de inductie)
-- vrem sa dem succ n + 0 = succ n
-- succ n + 0 = succ (n + 0) (aplicand P2 cu x' = n si y = 0)
--            = succ n       (aplicand ipoteza de inductie)

theorem n_plus_0_eq_n (n : Natural) : Natural.add n (Natural.zero) = n := by
  induction n
  case zero =>
    exact Natural.add._eq_1 $ Natural.zero
  case succ n' ih =>
    rw [Natural.add._eq_2 (Natural.zero) n']
    rw [ih]

theorem add_comm (n m : Natural) : Natural.add n m = Natural.add m n := by
  induction n
  case zero =>
    simp [Natural.add]
