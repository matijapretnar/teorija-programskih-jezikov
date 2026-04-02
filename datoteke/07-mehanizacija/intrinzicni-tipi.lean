inductive Ty : Type where
| Bul : Ty
| Fun : Ty → Ty → Ty

notation:25 A " ⇒ " B => Ty.Fun A B

inductive Ctx : Type where
| empty : Ctx
| snoc : Ctx → Ty → Ctx

inductive Var : Ctx → Ty -> Type where
| Z : Var (Ctx.snoc _ A) A
| S :
    Var Γ A →
    --------------------
    Var (Ctx.snoc Γ _) A

inductive Tm : Ctx -> Ty -> Type where
| tru : Tm Γ Ty.Bul
| fls : Tm Γ Ty.Bul
| ite : Tm Γ Ty.Bul → Tm Γ A → Tm Γ A → Tm Γ A
| var : Var Γ A → Tm Γ A
| lam : Tm (Ctx.snoc Γ A) B → Tm Γ (Ty.Fun A B)
| app : Tm Γ (Ty.Fun A B) → Tm Γ A → Tm Γ B

-- Primer: kompozitum
    -- λf².λg¹.λx⁰.f (g x)
    -- λ.λ.λ.2 (1 0)

example {A B C} : Tm Ctx.empty ((B ⇒ C) ⇒ (A ⇒ B) ⇒ (A ⇒ C)) :=
    open Tm in
    open Var in
    lam ( lam ( lam (
        app (var (S (S Z))) (app (var (S Z)) (var Z))
    )))


-- def subst (x : Nat) (V : Tm) : Tm → Tm
-- | Tm.tru => Tm.tru
-- | Tm.fls => Tm.fls
-- | Tm.ite M N1 N2 => Tm.ite (subst x V M) (subst x V N1) (subst x V N2)
-- | Tm.var y => sorry
-- | Tm.lam M => sorry
-- | Tm.app M N => Tm.app (subst x V M) (subst x V N)

-- inductive IsValue : Tm _ _ → Prop where
-- | tru : IsValue Tm.tru
-- | fls : IsValue Tm.fls
-- | lam : IsValue (Tm.lam _)

inductive Step : Tm Γ A → Tm Γ A → Prop where
| ite_step :
    Step M M' →
    ---------------------------------------
    Step (Tm.ite M N1 N2) (Tm.ite M' N1 N2)
| ite_tru :
    -----------------------------
    Step (Tm.ite Tm.tru N1 N2) N1
| ite_fls :
    -----------------------------
    Step (Tm.ite Tm.fls N1 N2) N2
| app_step1 :
    Step M M' →
    -------------------------------
    Step (Tm.app M N) (Tm.app M' N)
| app_step2 :
    -- IsValue V →
    Step N N' →
    -------------------------------
    Step (Tm.app V N) (Tm.app V N')
-- | app_lam :
--     IsValue V →
--     ----------------------------------------
--     Step (Tm.app (Tm.lam M) V) (subst 0 V M)

set_option pp.fieldNotation false

inductive Progresses : Tm → Prop where
| step : Step M M' → Progresses M
| value : IsValue M → Progresses M

theorem progress :
    Γ = Ctx.empty →
    HasType Γ M A →
    Progresses M :=
by
    intro h_ctx h_typ
    induction h_typ
    case tru =>
        exact Progresses.value IsValue.tru
    case fls =>
        exact Progresses.value IsValue.fls
    case ite M_ih N1_ih N2_ih =>
        cases (M_ih h_ctx)
        case step M_step =>
            exact Progresses.step (Step.ite_step M_step)
        case value M_val =>
            cases M_val
            case tru =>
                exact Progresses.step (Step.ite_tru)
            case fls =>
                exact Progresses.step (Step.ite_fls)
            case lam =>
                contradiction
    case var =>
        rename_i tezava
        rewrite [h_ctx] at tezava
        cases tezava
    sorry
    sorry
