% Filename: homework.cls
% Author: Andriy Zhugayevych  azh@ukr.net
% Options:

\NeedsTeXFormat{LaTeX2e}[1994/12/01]
\ProvidesClass{homework}[2014/01/28 Article class]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[11pt,a4paper]{article}

\DeclareOption*{}
\DeclareOption{a4paper}{    \setlength{\textwidth}{185mm}\setlength{\textheight}{260mm}}
\DeclareOption{letterpaper}{\setlength{\textwidth}{190mm}\setlength{\textheight}{240mm}}
\ExecuteOptions{a4paper} % default paper size
\ProcessOptions\relax

\RequirePackage[pdfpagemode=UseNone,pdfstartview={}]{hyperref}


% Page layout
\setlength{\topmargin}{-20mm}
\setlength{\oddsidemargin}{-10mm}
\setlength{\evensidemargin}{-10mm}


% Make title
\renewcommand{\maketitle}{
\thispagestyle{empty}
\noindent
\begin{center}
{\large\bfseries Computational Chemistry and Materials Modeling\par}
\vskip 0.5ex
{\large\bfseries \@title \par}
\end{center}
}

