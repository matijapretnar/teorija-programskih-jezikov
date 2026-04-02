inductive Ty : Type where
| Bul : Ty
| Fun : Ty → Ty → Ty

inductive Tm : Type where
| tru : Tm
| fls : Tm
| ite : Tm → Tm → Tm → Tm
| var : Nat → Tm
| lam : Tm → Tm
| app : Tm → Tm → Tm

-- Primer: kompozitum
    -- λf².λg¹.λx⁰.f (g x)
    -- λ.λ.λ.2 (1 0)

example : Tm :=
    open Tm in
    lam ( lam ( lam (
        app (var 2) (app (var 1) (var 0))
    )))


def subst (x : Nat) (V : Tm) : Tm → Tm
| Tm.tru => Tm.tru
| Tm.fls => Tm.fls
| Tm.ite M N1 N2 => Tm.ite (subst x V M) (subst x V N1) (subst x V N2)
| Tm.var y => sorry
| Tm.lam M => sorry
| Tm.app M N => Tm.app (subst x V M) (subst x V N)

inductive Ctx : Type where
| empty : Ctx
| snoc : Ctx → Ty → Ctx

-- x : A ∈ Γ
inductive VarType : Ctx → Nat → Ty → Prop where
| here : VarType (Ctx.snoc _ A) Nat.zero A
| there :
    VarType Γ x A →
    -------------------------------------
    VarType (Ctx.snoc Γ _) (Nat.succ x) A

-- Γ ⊢ M : A
inductive HasType : Ctx → Tm → Ty → Prop where
| tru : HasType Γ Tm.tru Ty.Bul
| fls : HasType Γ Tm.fls Ty.Bul
| ite :
    HasType Γ M Ty.Bul →
    HasType Γ N1 A →
    HasType Γ N2 A →
    --------------------------
    HasType Γ (Tm.ite M N1 N2) A
| var :
    VarType Γ x A →
    ----------------------
    HasType Γ (Tm.var x) A
| lam :
    HasType (Ctx.snoc Γ A) M B →
    ---------------------------------
    HasType Γ (Tm.lam M) (Ty.Fun A B)
| app :
    HasType Γ M (Ty.Fun A B) →
    HasType Γ N A →
    ----------------------
    HasType Γ (Tm.app M N) B

inductive IsValue : Tm → Prop where
| tru : IsValue Tm.tru
| fls : IsValue Tm.fls
| lam : IsValue (Tm.lam _)

inductive Step : Tm → Tm → Prop where
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
    IsValue V →
    Step N N' →
    -------------------------------
    Step (Tm.app V N) (Tm.app V N')
| app_lam :
    IsValue V →
    ----------------------------------------
    Step (Tm.app (Tm.lam M) V) (subst 0 V M)

set_option pp.fieldNotation false

theorem preservation :
    HasType Γ M A →
    Step M M' →
    HasType Γ M' A :=
by
    intro h_typ h_step
    induction h_step generalizing A
    case ite_step h_step' ih =>
        cases h_typ
        case ite M_typ N1_typ N2_typ =>
            have M'_typ := ih M_typ
            exact HasType.ite M'_typ N1_typ N2_typ
    case ite_tru =>
        cases h_typ
        case ite M_typ N1_typ N2_typ =>
            exact N1_typ
    case ite_fls =>
        cases h_typ
        case ite M_typ N1_typ N2_typ =>
            exact N2_typ
    sorry
    sorry
    sorry

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
