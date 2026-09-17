# Flutter Mobile App Implementation Skill

## Purpose

Build the provided UI/UX design into a real, production-quality Flutter
mobile application.

The UI and UX decisions have already been completed. Do **not** redesign
the product or rethink the core user flows unless an implementation
constraint makes the existing design impossible.

The primary job is to translate the approved design into: - Flutter
screens - reusable widgets - navigation - interactions - local/mock
state where APIs are not ready - responsive mobile layouts - proper
loading, empty, error, success, and disabled states - clean architecture
that can later connect to real APIs

------------------------------------------------------------------------

## Core Principle

**Design → Implement, do not redesign.**

The supplied Figma/screenshots/design files are the source of truth
for: - layout - spacing - typography - colors - border radius - icon
placement - component hierarchy - visual states - navigation intent

If something is visually ambiguous, choose the simplest implementation
that preserves the intended UX.

Do not introduce: - unnecessary gradients - arbitrary colors - excessive
animations - unrelated UI patterns - new features - unnecessary
dependencies - web-style layouts inside the mobile app

------------------------------------------------------------------------

## Product Scope

The application is a wallet / financial-services style mobile app.

The Home screen includes concepts such as:

-   Wallet balance
-   QR
-   Transfer
-   Cash In
-   Cash Out
-   Tickets / Active Passes
-   Services
    -   Top Up
    -   Pay Bills
    -   Gift Cards
    -   Deals
    -   Events
    -   Movies
    -   Insurance
    -   More
-   Promotional banner
-   Transaction filters
-   Transaction list
-   Transaction details

Other features should follow the approved UX/design specification.

Do not assume that the visible Home screen is the complete application.
Implement the complete approved feature set when its screens and flows
are provided.

------------------------------------------------------------------------

# Development Workflow

Follow this order strictly.

## Phase 1 --- Inspect Before Coding

Before writing UI code:

1.  Inspect the existing Flutter project.
2.  Inspect all available design assets.
3.  Inspect the complete screen list.
4.  Identify navigation flows.
5.  Identify reusable UI patterns.
6.  Identify data models implied by the screens.
7.  Identify which parts require mock data versus future API
    integration.
8.  Check the existing `pubspec.yaml` before adding dependencies.

Do not immediately generate a large amount of code.

------------------------------------------------------------------------

## Phase 2 --- Establish App Foundation

Create or verify:

``` text
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── router/
│   └── theme/
├── core/
│   ├── constants/
│   ├── extensions/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/
│   ├── home/
│   ├── wallet/
│   ├── transfer/
│   ├── cash_in/
│   ├── cash_out/
│   ├── qr/
│   ├── tickets/
│   ├── services/
│   └── transactions/
└── data/
    ├── models/
    ├── repositories/
    └── mock/
```

Adapt this structure if the existing project already has a better
established architecture.

Do not reorganize a healthy existing codebase without a reason.

------------------------------------------------------------------------

# Architecture Rules

Use feature-based organization.

Prefer:

``` text
feature/
├── data/
├── domain/
├── presentation/
└── ...
```

when the project complexity requires it.

For smaller features, keep the structure practical rather than creating
unnecessary abstraction.

## Separation of concerns

UI widgets should not contain: - API implementation - database queries -
authentication logic - large business rules

Use a separation such as:

``` text
Screen
  ↓
Controller / State
  ↓
Repository
  ↓
API / Mock Data
```

The exact state-management solution should follow the existing project
or project requirements.

Do not add a state-management package simply because it is popular.

------------------------------------------------------------------------

# Design System

Create centralized design tokens.

At minimum define:

-   primary colors
-   background colors
-   surface colors
-   text colors
-   border colors
-   typography
-   spacing
-   corner radius
-   shadows
-   icon sizing

Avoid hardcoding the same value repeatedly.

Example:

``` dart
AppSpacing.md
AppRadius.card
AppColors.primary
AppTextStyles.bodyMedium
```

The actual values must come from the approved design.

------------------------------------------------------------------------

# Responsive Mobile UI

The app must behave like a real mobile application.

Support common phone sizes.

Avoid: - fixed screen-width assumptions - arbitrary absolute
positioning - desktop-style layouts - overflow - hardcoded heights that
break on smaller devices

Prefer:

``` dart
SafeArea
LayoutBuilder
MediaQuery
Expanded
Flexible
Padding
SizedBox
ListView
CustomScrollView
Sliver*
```

Use scrolling deliberately.

The Home screen should remain usable when content exceeds the viewport.

------------------------------------------------------------------------

# Component Strategy

Break repeated UI into reusable widgets.

For example:

``` text
BalanceCard
QuickActionCard
TicketCard
ServiceItem
ServiceGrid
PromoBanner
TransactionFilter
TransactionTile
SectionHeader
PrimaryButton
SecondaryButton
AppTextField
```

A reusable component should be created when: - it appears more than
once - it has meaningful internal behavior - it represents a clear
design-system component

Do not create hundreds of tiny files for trivial one-line widgets.

------------------------------------------------------------------------

# Home Screen

The Home screen should follow the approved design hierarchy.

Conceptually:

``` text
SafeArea
└── Scrollable Content
    ├── Wallet / Balance Card
    ├── Quick Actions
    │   ├── Transfer
    │   ├── Cash In
    │   └── Cash Out
    ├── Tickets Card
    ├── Services
    │   ├── Top Up
    │   ├── Pay Bills
    │   ├── Gift Cards
    │   ├── Deals
    │   ├── Events
    │   ├── Movies
    │   ├── Insurance
    │   └── More
    ├── Promotional Banner
    └── Transactions
```

The exact layout must follow the supplied design rather than this
conceptual structure.

------------------------------------------------------------------------

# Navigation

Every interactive element shown as actionable in the design must have
appropriate behavior.

Examples:

``` text
Home
 ↓
Transfer
 ↓
Recipient
 ↓
Amount
 ↓
Review
 ↓
Authentication
 ↓
Success
```

Do not create dead-end buttons.

For unfinished backend-dependent actions: - implement the screen flow -
use mock data - clearly separate mock behavior from production API
behavior

Navigation should be centralized rather than scattered throughout
arbitrary widgets.

------------------------------------------------------------------------

# State Handling

Every important screen should consider:

## Loading

``` text
Loading
  ↓
Success
```

## Error

``` text
Loading
  ↓
Error
  ↓
Retry
```

## Empty

``` text
Loaded
  ↓
No data
  ↓
Empty state
```

## Success

For operations such as: - transfer - cash in - cash out - top up - bill
payment

provide the appropriate success state from the approved UX.

## Disabled

Buttons should correctly represent: - invalid input - unavailable
action - processing - permission restrictions

------------------------------------------------------------------------

# Mock Data

When the backend is unavailable, use realistic mock data.

Example:

``` dart
class MockWalletRepository {
  Future<Wallet> getWallet() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return Wallet(
      balance: 125000,
      points: 661,
    );
  }
}
```

Do not scatter mock values throughout UI widgets.

Bad:

``` dart
Text("125,000 MMK")
```

everywhere.

Prefer:

``` dart
Text(wallet.formattedBalance)
```

The UI should be easy to connect to real APIs later.

------------------------------------------------------------------------

# Data Models

Create models for meaningful domain objects.

Examples:

``` text
User
Wallet
Transaction
Recipient
Ticket
Service
Promotion
Bill
Payment
```

Models should contain data only or lightweight presentation helpers.

Avoid putting network calls directly into models.

------------------------------------------------------------------------

# API Readiness

Even when using mock data, design the code so that the repository can
later switch to an API.

Prefer:

``` text
HomeController
      ↓
WalletRepository
      ↓
MockWalletDataSource
```

Later:

``` text
HomeController
      ↓
WalletRepository
      ↓
ApiWalletDataSource
      ↓
Backend
```

Do not couple the entire UI to a specific API implementation.

------------------------------------------------------------------------

# Forms and Validation

For: - transfer - cash in - cash out - top up - bill payment -
authentication

implement proper input handling.

Validation should happen before submission.

Examples: - required fields - valid amount - minimum / maximum amount -
valid phone/account identifier - insufficient balance - invalid PIN -
confirmation mismatch

Error messages should be clear and user-friendly.

------------------------------------------------------------------------

# Financial UI Rules

Because this is a wallet/financial-style application:

-   format currency consistently
-   never silently round monetary values
-   clearly distinguish income and expense
-   show transaction status explicitly
-   prevent accidental double submission
-   disable submit buttons while processing
-   never expose sensitive credentials in UI logs
-   never hardcode production secrets
-   do not log PINs, tokens, passwords, or sensitive financial data

Use appropriate numeric types for money rather than relying on
floating-point arithmetic for financial calculations.

------------------------------------------------------------------------

# Interaction Quality

The app should feel native and responsive.

Implement where appropriate:

-   tap feedback
-   button loading states
-   page transitions
-   pull-to-refresh
-   keyboard handling
-   scroll behavior
-   back navigation
-   confirmation dialogs
-   bottom sheets
-   snackbars
-   success feedback

Do not over-animate.

Animations should support understanding rather than decorate the UI.

------------------------------------------------------------------------

# Accessibility

Consider:

-   sufficient touch target sizes
-   readable text
-   semantic labels
-   sufficient contrast
-   scalable text where practical
-   clear error messages

Icons should not be the only indication of important actions or states.

------------------------------------------------------------------------

# Assets

Use the supplied assets whenever available.

Do not replace approved assets with: - random icons - emoji - unrelated
stock images - generated placeholders

Keep assets organized.

Example:

``` text
assets/
├── icons/
├── images/
├── logos/
└── fonts/
```

Register them correctly in `pubspec.yaml`.

------------------------------------------------------------------------

# Code Quality

Follow normal Dart / Flutter conventions.

Prefer:

``` dart
const
final
immutable widgets
small focused methods
meaningful names
```

Avoid:

``` dart
dynamic everywhere
giant build() methods
duplicated UI
magic numbers
unused packages
unused imports
dead code
```

Do not over-engineer.

Readable code is more important than clever code.

------------------------------------------------------------------------

# AI Coding Rules

If an AI coding agent is being used:

## Before changing code

The agent must: 1. inspect the repository 2. understand the current
architecture 3. inspect relevant existing components 4. identify
dependencies 5. make a small implementation plan

## During implementation

Work feature-by-feature.

Preferred order:

``` text
Project foundation
↓
Theme / Design Tokens
↓
Navigation
↓
Reusable Components
↓
Home
↓
Wallet
↓
Transfer
↓
Cash In / Cash Out
↓
QR
↓
Tickets
↓
Services
↓
Transactions
↓
Authentication / Security
↓
API integration
```

Do not modify unrelated files.

Do not rewrite the entire project when only one screen is requested.

------------------------------------------------------------------------

# Visual Fidelity

After implementing each screen:

1.  Run the Flutter app.
2.  Compare it against the approved design.
3.  Check:
    -   spacing
    -   typography
    -   alignment
    -   sizing
    -   colors
    -   border radius
    -   shadows
    -   icons
    -   scrolling
    -   responsive behavior
4.  Fix visual differences.
5.  Then continue to the next feature.

Do not declare a screen complete simply because it compiles.

------------------------------------------------------------------------

# Testing

At minimum verify:

## Build

``` bash
flutter analyze
flutter test
flutter run
```

## Manual checks

-   app launches
-   navigation works
-   back button works
-   buttons respond
-   lists scroll
-   forms validate
-   loading states work
-   error states work
-   success states work
-   keyboard does not break layouts
-   no overflow errors
-   no obvious visual mismatch

For important business logic, add unit/widget tests.

------------------------------------------------------------------------

# Error Prevention

Before finishing a task, check for:

``` text
RenderFlex overflow
Missing asset
Incorrect route
Null exception
Unbounded height
Unbounded width
Keyboard overflow
Duplicate navigation
Double submission
Incorrect currency formatting
Broken back navigation
```

Fix errors instead of hiding them.

Do not use `try/catch` to silently suppress unknown errors.

------------------------------------------------------------------------

# Security

Never commit:

``` text
API keys
JWT secrets
private keys
passwords
database credentials
production tokens
```

Use environment/configuration mechanisms appropriate to the project.

Authentication and authorization must ultimately be enforced by the
backend. Flutter-side checks are only UX protections.

------------------------------------------------------------------------

# Definition of Done

A feature is complete only when:

-   [ ] UI matches the approved design
-   [ ] UX flow works
-   [ ] navigation works
-   [ ] loading state works
-   [ ] empty state works where relevant
-   [ ] error state works where relevant
-   [ ] success state works where relevant
-   [ ] validation works
-   [ ] mock/API data is separated from presentation
-   [ ] responsive behavior is acceptable
-   [ ] no overflow errors
-   [ ] `flutter analyze` passes
-   [ ] relevant tests pass
-   [ ] code is clean and maintainable

------------------------------------------------------------------------

# Final Principle

The product design is already decided.

The implementation goal is:

> **Turn the approved UI + UX into a real Flutter mobile application
> without changing the product unnecessarily.**

Prioritize:

**Correctness → UX behavior → Visual fidelity → Maintainability →
Performance**

Build the actual app, not just a collection of screenshots.
