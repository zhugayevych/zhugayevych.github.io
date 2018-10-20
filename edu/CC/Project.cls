% Filename: Project.cls
% Author: Andriy Zhugayevych  azh@ukr.net
% Options:

\NeedsTeXFormat{LaTeX2e}[1994/12/01]
\ProvidesClass{Homework}[2014/01/28 Project class]
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
\end{center}}


% Preface
\newcommand{\preface}[1]{
\par
Formulate your own project within the above defined topic or do one of the following projects. \par #1}


% Reminder
\newcommand{\reminder}[1]{
\bigskip\par
\textbf{Reminder:} This is a scientific project whose more or less complete solution has a complexity scale of a peer-reviewed publication. That is why a precise exhaustive solution is not required. But try to do your best, spending a reasonable amount of time (about 2 hours per week per team member). It is expected that you will take TA's advisory on team-projects. Prepare 10~min oral presentation (introduction, motivation, methodology, main results, conclusions) and be ready for additional 10~min of discussion. Very short written report is also required and should contain the information on participation of each team member. \par #1}
