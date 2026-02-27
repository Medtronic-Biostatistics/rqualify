# Background

R-IQ-OQ is an R/RMarkdown based program designed to serve as a
foundation for the Installation Qualification (IQ) and Operational
Qualification (OQ) of R (<http://www.r-project.org/>) when used in
environments (such as regulated clinical trials) where such processes
may be required.

In these environments, documentation is typically required to
demonstrate that software applications have been installed correctly
using vendor defined procedures and that the application is operating
correctly, using a pre-defined set of tests.

The R-validation.Rmd file will generate an automated report that
provides output that can be part of **user defined and created**
standard operating procedures (SOPs) in which such IQ and OQ tests are
performed. These post-installation tests are defined by the R Foundation
in the `R Installation and Administration Manual` available at:

[http://cran.r-project.org/doc/manuals/R-admin.html](http://cran.r-project.org/doc/manuals/R-admin.md)

For regulated clinical trials, the R Foundation also provides a document
entitled:

    R: Regulatory Compliance and Validation Issues A Guidance Document for the Use of R in Regulated Clinical Trial Environments

available from:

<http://www.r-project.org/doc/R-FDA.pdf>

which provides guidance on the use of R in such environments, including
references to relevant FDA regulatory guidance documents, descriptions
of R’s Software Development Life Cycle (SDLC) and information regarding
the applicability of various aspects of Title 21 of the U.S. Code of
Federal Regulations Part 11 (21 CFR 11) and how R fits within that
framework.

Note that there is also a more general description of R’s Software
Development Life Cycle (SDLC), which is available from:

<http://www.r-project.org/doc/R-SDLC.pdf>

and contains a subset of the relevant content from the R-FDA document,
excluding the content that is specifically targeted to clinical trials.

It is important to note that the output of the R-IQ-OQ program is
designed to serve as a general purpose template for use by those
operating in environments where installation and operational
qualification of software applications is deemed to be needed. The
structure and content of the resultant report may not satisfy all needs
and you are free to modify the report as your local requirements and
SOPs may necessitate.

Please note that all programs are made available under the GNU GPL
version 2 license, so please observe the copyright and distribution
requirements of that license. See the `LICENSE` file included.
