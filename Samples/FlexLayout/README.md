# FlexLayout

## What is the essence

FlexLayout is a library providing collections of: 
    - cell containers (or, more specifically, sections of cells; for now, the only available section is FlexItems)
    - cells (since the module utilizes content/background configuration API, cell's configs are provided)

Library is developed in two orthogonal dimensions since cell containers and cells are independent from each other. Multiple types of cells are used with different types of containers.

## Usage

Module's entry point is `FLAssembly`. It accepts a list of FLSection as input and produces a list of matching `FLSectionViewResult`.
FLSection provides a factory for section and a factory for cells. Clients choose library factories or provide their own.
FLSectionViewResult contains an instance of view controller, containing the section view and interactor which provides an access to section's state.     
