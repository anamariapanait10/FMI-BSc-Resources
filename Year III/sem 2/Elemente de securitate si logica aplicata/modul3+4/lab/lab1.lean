#eval 1 + 1

#check 1

def plus5 (n: Nat) : Nat := n + 5

#eval plus5 5


#check fun n : Nat => n + 5

def plus5' := fun n: Nat => n + 5
#eval plus5' 5

-- Exercitiul 1
def applyFunction (α β : Type) (a : α) (f : α → β) : β := f a

#check applyFunction
#eval applyFunction Nat Bool 2 (fun x => x > 2)

def applyFunction' {α β : Type} (a : α) (f : α → β) : β := f a
#check applyFunction'

-- Exercitiul 4
def swap {α β : Type} (p : Prod α β) : Prod β α :=
  match p with
  | (a, b) => (b, a)

#check swap
#eval swap (Prod.mk 1 2)

open Nat

def isZero (n: Nat) : Bool :=
  match n with
  | zero => true
  | succ _ => false

def isZero' : Nat → Bool
| zero => true
| succ _ => false
/-
  Definitions by pattern matching can also be recursive.
-/
def nthSum : Nat → Nat
| zero => zero
| succ n => (succ n) + nthSum n

/-
  There are builtin notations like `0` for `zero` and `n + 1` for `succ n` but they are the same thing under the hood.
-/
def nthSum' : Nat → Nat
| 0 => 0
| n + 1 => (n + 1) + nthSum n

-- Exercitiul 5
def factorial : Nat → Nat
  | zero => succ zero
  | succ n => succ n * factorial n

#eval factorial 5
example : factorial 5 = 120 := rfl

#check Option.some
def sub?: Nat -> Nat -> Option Nat:=
  fun x y =>
  if x < y then none else some (x - y)

#eval sub? 10 2
#eval sub? 2 7

-- Exercitiul 7
def myAdd : Nat → Nat → Nat
  | zero, n => n
  | succ n, m => succ (myAdd n m)
example : myAdd 28 49 = 77 := rfl
-- 0 + n = n
example (n : Nat) : myAdd 0 n = n := rfl -- error, because we pattern matched on the second argument in the definition of `myAdd`

-- n + 0 = n
example (n : Nat) : myAdd n 0 = n := rfl

inductive Natural
| zero : Natural
| succ : Natural -> Natural

#check @Natural.succ
#reduce Natural.succ $ Natural.succ $ Natural.zero

-- simp = simplification rule
@[simp]
def Natural.add : Natural -> Natural -> Natural :=
  fun x y =>
  match x with
  | zero => y
  | succ x' => succ (Natural.add x' y)

#check Natural.add._eq_1
#check Natural.add._eq_2

theorem n_plus_0_eq_n (n: Natural): Natural.add n (Natural.zero) = n := by
induction n
case zero => exact Natural.add._eq_1 $ Natural.zero
case succ n' ih => -- ih = induction hypothesis
  rw [Natural.add._eq_2 (Natural.zero) n']
  rw [ih]


theorem add_commm (n m: Natural): Natural.add n m = Natural.add m n := by
 sorry


-- lema ajutatoare
theorem aux (n m : Natural) : Natural.add (Natural.succ n) m = Natural.add n (Natural.succ m) :=
  by
    induction n
    case zero =>
      rw [Natural.add._eq_1 (Natural.succ m)]
      rw [Natural.add._eq_2 m]
      rw [Natural.add._eq_1 m]
    case succ n' ih =>
      rw [Natural.add._eq_2 m]
      rw [ih]
      rw [Natural.add._eq_2 (Natural.succ m)]

-- comutativitatea adunarii
theorem add_comm (n m : Natural) : Natural.add n m = Natural.add m n :=
  by
    induction n
    case zero =>
      rw [Natural.add._eq_1 m]
      rw [n_plus_0_eq_n]
    case succ n' ih =>
      rw [Natural.add._eq_2 m]
      rw [ih]
      rw [<-aux m n'] -- rescrie membrul drept din aux
      rw [Natural.add._eq_2 n']


theorem aux (n m : Natural) : Natural.add (Natural.succ n) m = Natural.add n (Natural.succ m) :=
  by
    induction n
    case zero => simp
    case succ n' ih => rw [Natural.add._eq_2, ih, Natural.add._eq_2]

theorem add_comm (n m : Natural) : Natural.add n m = Natural.add m n :=
  by
    induction n
    case zero => simp; rw [n_plus_0_eq_n]
    case succ n' ih => rw [Natural.add._eq_2, ih, <-aux, Natural.add._eq_2]
