# muffins.jl
**muffins.jl** is a Julia package for solving the **Muffin Problem**:
> *Given* __m__ *muffins and* __s__ *students, divide the muffins in such a way that all students can receive equal amounts of muffin.  
> Determine* __muffins(m, s)__*, the largest possible minimum muffin piece cut*

The Muffin Problem was first proposed by Alan Frank in 2011. Algorithms and solution methods were later extensively developed in *The Muffin Book* (2019), a collaboration between William Gasarch, Erik Metz, Jacob Prinz, and Daniel Smolyak among others.

The theorems and conjectures referenced by **Muffins.jl** are expanded upon and proven on the **[Muffin Website](https://www.cs.umd.edu/users/gasarch/MUFFINS/muffins.html)** and in *The Muffin Book*.

## Requirements
**Muffins.jl** is built and tested for Julia v1.1.  
Download the appropriate version of Julia **[here](https://julialang.org/downloads/)**.

## Installation
Run `julia` in the terminal to open the Julia REPL and load the package by entering the following commands after the `julia>` prompt:

```julia
using Pkg
Pkg.add("https://github.com/antarahebbar/muffins")
using Muffins
```

## Usage
Let `m` and `s` be predefined positive `Int64`-type variables. Let `α` be a predefined positive `Rational{Int64}`-type variable.

### General Solution
Run `Minipackage.muffins(m,s)`* to solve the Muffin Problem for `m` muffins and `s` students.  The package will find the minimum of alphas outputted by floor-ceiling, int, and half methods.
An upper bound `α` for `muffins(m, s)` is determined by testing (`m`, `s`) on all of the bounding methods in the package (see **Bounding methods**). The upper bound `α` is then verified to be a lower bound for `muffins(m, s)` by finding a procedure where `α` is the smallest muffin piece cut (see **FindProc**). If all tests are conclusive, `α`, a proof, and solutions are returned to`muffins(m, s)`.

### Bounding methods
#### Floor-Ceiling Theorem
Run `muffins.fc(m, s)`^ to apply the Floor-Ceiling Theorem on (`m`, `s`) to find an upper bound `α` for `muffins(m, s)`. `α` is returned.

#### Half Method
Run `muffins.half(m, s)`* to apply the Half Method on (`m`, `s`) to find an upper bound `α` for `muffins(m, s)`. `α` is returned.
Program automatically runs `muffins.vhalf1(m, s, α)`* to verify whether the Half Method can prove that the given `α` is an upper bound for `muffins(m, s)`. 0 is returned if vhalf verifies alpha, -1 is returned if it does not. 
Optionally run `muffins.halfproof(m,s,a)` or `muffins.half(m,s,true)` to output a proof of the half method with interval diagrams.  

#### Interval Method
Run `muffins.int(m, s)`* to apply the Interval Method on (`m`, `s`) to find an upper bound `α` for `muffins(m, s)`. `α` is returned.  
Program automatically runs `muffins.vint1(m, s, α)`* to verify whether the Int Method can prove that the given `α` is an upper bound for `muffins(m, s)`. 0 is returned if vint1 verifies alpha, -1 is returned if it does not.
Optionally run `muffins.intproof(m,s,a)` or `muffins.int(m,s,true)` to output a proof of the int method with interval diagrams.  

### Midpoint Method
More to come on midpoint method, vmid, and midproof. This method is not included in the minipackage.

<!--- More method documentation to come -->

### FindProc
Run `muffins.findproc(m, s, α)`^ to display potential procedures/solutions for dividing `m` muffins among `s` students where `α` is the smallest muffin piece cut. A solutions array is returned.
