data Ty : Set where
    BOOL : Ty
    _⇒_ : Ty → Ty → Ty

data Nat : Set where
    Z : Nat
    S : Nat → Nat

data Tm : Set where
    VAR : Nat → Tm
    TRUE : Tm
    FALSE : Tm
    IF_THEN_ELSE_ : Tm → Tm → Tm → Tm
    _∙_ : Tm → Tm → Tm
    ƛ : Tm → Tm

data value : Tm → Set where
    value-TRUE :
        ----------
        value TRUE

    value-FALSE :
        -----------
        value FALSE

    value-LAMBDA : {M : Tm} → 
        -----------
        value (ƛ M)

subst : (Nat → Tm) → Tm → Tm
subst σ (VAR x) = σ x
subst σ TRUE = TRUE
subst σ FALSE = FALSE
subst σ (IF M THEN M₁ ELSE M₂) = IF (subst σ M) THEN (subst σ M₁) ELSE (subst σ M₂)
subst σ (M ∙ M₁) = subst σ (M) ∙ (subst σ M₁)
subst σ (ƛ M) = ƛ (subst {!   !} M)

_[_] : Tm → Tm → Tm
M [ N ] = subst σ M where
    σ : Nat → Tm
    σ Z = N
    σ (S n) = VAR n

data Ctx : Set where
    ∅ : Ctx
    _,_ : Ctx → Ty → Ctx

data _⦂_∈_ : Nat → Ty → Ctx → Set where
    Z : {Γ : Ctx} {A : Ty} →
       --------------
       Z ⦂ A ∈ (Γ , A)

    S : {Γ : Ctx} {n : Nat} {A B : Ty} →
       n ⦂ A ∈ Γ →
       ----------------
       S n ⦂ A ∈ (Γ , B)

data _⊢_⦂_ : Ctx → Tm → Ty → Set where
    VAR : {Γ : Ctx} {n : Nat} {A : Ty} →
        n ⦂ A ∈ Γ →
        -------------
        Γ ⊢ VAR n ⦂ A
    TRUE : {Γ : Ctx} →
        ---------------
        Γ ⊢ TRUE ⦂ BOOL
    FALSE : {Γ : Ctx} →
        ----------------
        Γ ⊢ FALSE ⦂ BOOL
    IF_THEN_ELSE_ : {Γ : Ctx} {M N₁ N₂ : Tm} {A : Ty} →
        Γ ⊢ M ⦂ BOOL →
        Γ ⊢ N₁ ⦂ A →
        Γ ⊢ N₂ ⦂ A →
        ------------------------------
        Γ ⊢ (IF M THEN N₁ ELSE N₂) ⦂ A
    _∙_ : {Γ : Ctx} {M N : Tm} {A B : Ty} →
        Γ ⊢ M ⦂ (A ⇒ B) →
        Γ ⊢ N ⦂ A →
        ---------------
        Γ ⊢ (M ∙ N) ⦂ B
    ƛ : {Γ : Ctx} {M : Tm} {A B : Ty} →
        (Γ , A) ⊢ M ⦂ B →
        ---------------
        Γ ⊢ (ƛ M) ⦂ (A ⇒ B)

data _↝_ : Tm → Tm → Set where
    IF-TRUE : {N₁ N₂ : Tm} →
        ------------------------------
        (IF TRUE THEN N₁ ELSE N₂) ↝ N₁
    IF-FALSE : {N₁ N₂ : Tm} →
        -------------------------------
        (IF FALSE THEN N₁ ELSE N₂) ↝ N₂
    IF-STEP : {M M' N₁ N₂ : Tm} →
        M ↝ M' →
        ------------------------------------------------
        (IF M THEN N₁ ELSE N₂) ↝ (IF M' THEN N₁ ELSE N₂)
    APP-STEP1 : {M M' N : Tm} →
        M ↝ M' →
        ------------------
        (M ∙ N) ↝ (M' ∙ N)
    APP-STEP2 : {V N N' : Tm} →
        value V →
        N ↝ N' →
        ------------------
        (V ∙ N) ↝ (V ∙ N')
    APP-BETA : {M V : Tm} →
        value V →
        -------------------
        (ƛ M ∙ V) ↝ (M [ V ])

        -- α-ekvivalenca : λ x. ..x.. = λ y. ..y..
        -- β-ekvivalenca/redukcija : (λ x. M) N = M[N / x]
        -- η-ekvivalenca/ekspanzija : M = λ x. M x

preservation : {Γ : Ctx} {M M' : Tm} {A : Ty} →
    Γ ⊢ M ⦂ A →
    M ↝ M' →
    ----------
    Γ ⊢ M' ⦂ A
preservation (IF Γ⊢TRUE⦂BOOL THEN Γ⊢M'⦂A ELSE Γ⊢N₂⦂A) IF-TRUE = Γ⊢M'⦂A
preservation Γ⊢M⦂A IF-FALSE = {!   !}
preservation (IF Γ⊢M⦂A THEN Γ⊢M⦂A₁ ELSE Γ⊢M⦂A₂) (IF-STEP M↝M') =
    IF (preservation Γ⊢M⦂A M↝M') THEN Γ⊢M⦂A₁ ELSE Γ⊢M⦂A₂
preservation Γ⊢M⦂A (APP-STEP1 M↝M') = {!   !}
preservation Γ⊢M⦂A (APP-STEP2 x M↝M') = {!   !}
preservation Γ⊢M⦂A (APP-BETA x) = {!   !}

data progresses : Tm → Set where
    is-value : {M : Tm} →
        value M →
        ------------
        progresses M
    
    steps : {M M' : Tm} →
        M ↝ M' →
        ------------
        progresses M

progress : {M : Tm} {A : Ty} →
    ∅ ⊢ M ⦂ A →
    ------------
    progresses M
progress (VAR ())
progress TRUE = is-value value-TRUE
progress FALSE = is-value value-FALSE
progress (IF ⊢M⦂A THEN ⊢M⦂A₁ ELSE ⊢M⦂A₂) with progress ⊢M⦂A
... | is-value value-TRUE = steps IF-TRUE
... | is-value value-FALSE = steps IF-FALSE
... | steps M↝M' = steps (IF-STEP M↝M')
progress (⊢M⦂A ∙ ⊢M⦂A₁) = {!   !}
progress (ƛ ⊢M⦂A) = is-value value-LAMBDA
