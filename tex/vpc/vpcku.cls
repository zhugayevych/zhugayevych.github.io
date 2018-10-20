% Document class "vpcku" for LaTeX2e
% Authors: Denis Sheka, Andriy Zhugayevych
% created 24.09.2005,  modified 16.12.2005
% Клас для підготовки оригінал-макету книги для ВПЦ "Київський уніоверситет" за вимогами 2005 р.
%
%
% ------- Features -------
% 1) Only two papersizes are supported: 'a5paper' (default) and 'a4paper' (for draft printing).
% 2) The default option is 'twoside'.
% 2) The language is ukrainian.
% 3) Option 'nohref' means to not use hyperref (the default is to use).
%
%
\NeedsTeXFormat{LaTeX2e}[1998/12/01]
\ProvidesClass{vpcku}[2005/12/16 Standard LaTeX class]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\newif\if@afour   \DeclareOption{a4paper}{\@afourtrue}
\newif\if@oneside \DeclareOption{oneside}{\@onesidetrue}
\newif\if@nohref  \DeclareOption{nohref}{\@nohreftrue}
\if@afour\else\PassOptionsToClass{a5paper}{book}\fi
\if@oneside\else\PassOptionsToClass{twoside}{book}\fi
\ProcessOptions
\LoadClass{book}
\RequirePackage[ukrainian]{babel}
\RequirePackage[cp1251]{inputenc}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}
\if@nohref\else\RequirePackage{hyperref}\fi
\RequirePackage{makeidx}
\RequirePackage{multicol}
\RequirePackage{bm}           % похилі жирні латинські і жирні грецькі
\RequirePackage{soul}         % розрядка
\RequirePackage{wasysym}      % прямі інтеграли
%\RequirePackage{pscyr}        % покращені шрифти




% ------- Page layout and paragraph formatting -------
\if@afour
% A4paper
\textwidth 175mm \textheight 255mm
\oddsidemargin 20mm \evensidemargin 15mm
\parindent=9mm
\def\specitemindent{13mm}
\else
% A5paper
\textwidth 115mm \textheight 170mm
\oddsidemargin 16.5mm \evensidemargin 16.5mm
\topmargin 15mm \headheight 3mm \headsep 2mm
\parindent=5mm
\fi
% common
\hoffset -25.4mm \voffset -25.4mm
\renewcommand{\baselinestretch}{0.85}
\def\specitemindent{13mm}
\newcommand{\@specindent}{\hspace{\parindent}}
\AtBeginDocument{
  \abovedisplayskip=.5\abovedisplayskip
  \belowdisplayskip=.5\belowdisplayskip
  \abovedisplayshortskip=.3\abovedisplayshortskip
  \belowdisplayshortskip=.3\belowdisplayshortskip}



% ------- Headings and no footings -------
\pagestyle{headings}
% Simple headings
\renewcommand{\@evenhead}{\thepage\hfil\small\slshape\leftmark}
\renewcommand{\@oddhead}{{\small\slshape\rightmark}\hfil\thepage}
% Headings with rule
%\renewcommand{\@evenhead}{%
%  \raisebox{0pt}[\headheight][0pt]{%
%  \vbox{\hbox to\textwidth{\strut{\thepage\hfil\slshape\leftmark}}\hrule}}}
%\renewcommand{\@oddhead}{%
%  \raisebox{0pt}[\headheight][0pt]{%
%  \vbox{\hbox to\textwidth{\strut{{\slshape\rightmark}\hfil\thepage}}\hrule}}}
\renewcommand{\sectionmark}[1]{\markboth{\S~\thesection.~#1}{}}



% ------- Section headins -------
\renewcommand\section{\@startsection {section}{1}{\z@}%
  {3.5ex \@plus 1ex \@minus .2ex}%
  {2.3ex \@plus.2ex}%
  {\normalfont\Large\bfseries\raggedright}}
% Put \S mark before and period after section number
\def\@seccntformat#1{\@specindent\S\ \csname the#1\endcsname.\ }



% ------- Captions -------
% Put period after caption number in figures, tables etc.
% The origin of the code is unknown
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{#1. #2}%
  \ifdim \wd\@tempboxa >\hsize
    #1. #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}



% ------- Counters -------
% Remove resetting of section and figure counters
% The code of \providecommand is written by David Carlisle
\providecommand{\@removefromreset}[2]{{%
  \expandafter\let\csname c@#1\endcsname\@removefromreset
  \def\@elt##1{\expandafter\ifx\csname c@##1\endcsname\@removefromreset
  \else \noexpand\@elt{##1}\fi}%
  \expandafter\xdef\csname cl@#2\endcsname{\csname cl@#2\endcsname}}}
\@removefromreset{section}{chapter}
\@removefromreset{figure}{chapter}
% Define counters representation
\renewcommand{\thechapter}{\arabic{chapter}}
\renewcommand{\thesection}{\arabic{section}}
\renewcommand{\theequation}{\arabic{section}.\arabic{equation}}
\renewcommand{\thefigure}{\arabic{figure}}
\@addtoreset{equation}{section}



% ------- Formatting TOCs -------
\renewcommand*{\l@section}{\@dottedtocline{1}{1.5em}{1.5em}}
% Put period after section number in TOCs
% The origin of the code is unknown
\def\@sect#1#2#3#4#5#6[#7]#8{%
  \ifnum #2>\c@secnumdepth
    \let\@svsec\@empty
  \else
    \refstepcounter{#1}%
    \protected@edef\@svsec{\@seccntformat{#1}\relax}%
  \fi
  \@tempskipa #5\relax
  \ifdim \@tempskipa>\z@
    \begingroup
      #6{%
        \@hangfrom{\hskip #3\relax\@svsec}%
          \interlinepenalty \@M #8\@@par}%
    \endgroup
    \csname #1mark\endcsname{#7}%
    \addcontentsline{toc}{#1}{%
      \ifnum #2>\c@secnumdepth \else
        \protect\S\ \numberline{\csname the#1\endcsname. }% %%% Put period.
      \fi
      #7}%
  \else
    \def\@svsechd{%
      #6{\hskip #3\relax
      \@svsec #8}%
      \csname #1mark\endcsname{#7}%
      \addcontentsline{toc}{#1}{%
      \ifnum #2>0 {\csname #1name\endcsname. }  \fi %Put the sectname in "toc" file
        \ifnum #2>\c@secnumdepth \else
          \protect\numberline{\csname the#1\endcsname. }%
        \fi
        #7}}%
  \fi
  \@xsect{#5}}
\def\@ssect#1#2#3#4#5{%
  \@tempskipa #3\relax
  \ifdim \@tempskipa>\z@
    \begingroup
      #4{%
        \@hangfrom{\@specindent\hskip #1}%
          \interlinepenalty \@M #5\@@par}%
    \endgroup
  \else
    \def\@svsechd{#4{\@specindent\hskip #1\relax #5}}%
  \fi
  \@xsect{#3}}
% Put period after chapter number in TOCs
\def\@chapter[#1]#2{\ifnum \c@secnumdepth >\m@ne
                       \if@mainmatter
                         \refstepcounter{chapter}%
                         \typeout{\@specindent\@chapapp\space\thechapter\quad}%
                         \addcontentsline{toc}{chapter}%
                                   {\protect\@chapapp\ \numberline{\thechapter.}#1}%
                       \else
                         \addcontentsline{toc}{chapter}{#1}%
                       \fi
                    \else
                      \addcontentsline{toc}{chapter}{#1}%
                    \fi
                    \chaptermark{#1}%
                    \addtocontents{lof}{\protect\addvspace{10\p@}}%
                    \addtocontents{lot}{\protect\addvspace{10\p@}}%
                    \if@twocolumn
                      \@topnewpage[\@makechapterhead{#2}]%
                    \else
                      \@makechapterhead{#2}%
                      \@afterheading
                    \fi}
\def\@makechapterhead#1{%
%  \vspace*{50\p@}%
  {\parindent \z@ \raggedright \normalfont
    \ifnum \c@secnumdepth >\m@ne
      \if@mainmatter
      \fi
    \fi
    \interlinepenalty\@M
\par\ \quad\@specindent \begin{minipage}{0.9\textwidth}
\huge\bfseries \@chapapp\space\thechapter
\par\nobreak \vskip 20\p@
\Huge \bfseries  #1\par\nobreak
\end{minipage}
\vskip 30\p@
}}
\def\@makeschapterhead#1{%
%  \vspace*{50\p@}%
  {\parindent \z@ \raggedright
    \normalfont
    \interlinepenalty\@M
\par\ \quad\@specindent \begin{minipage}{0.9\textwidth}
\Huge \bfseries  #1\par\nobreak
\end{minipage}
\vskip 15\p@
}}



% ------- Some ukrainian settings -------
\def\@chapapp{Частина}
\addto\captionsukrainian{\def\bibname{{\cyr\CYRL\cyrii\cyrt\cyre\cyrr\cyra\cyrt\cyru\cyrr\cyra}}}



% ------- Mathematical commands -------
\DeclareMathOperator{\altRe}{Re} \renewcommand{\Re}{\altRe}
\DeclareMathOperator{\altIm}{Im} \renewcommand{\Im}{\altIm}
\DeclareMathOperator{\sgn}{sgn}
\DeclareMathOperator{\tr}{tr}
\DeclareMathOperator{\altsinh}{sh} \renewcommand{\sinh}{\altsinh}
\DeclareMathOperator{\altcosh}{ch} \renewcommand{\cosh}{\altcosh}
\DeclareMathOperator{\alttanh}{th} \renewcommand{\tanh}{\alttanh}
\DeclareMathOperator{\altcoth}{cth} \renewcommand{\coth}{\altcoth}
\DeclareMathOperator{\arcsh}{arcsh}
\DeclareMathOperator{\arcch}{arcch}
\DeclareMathOperator{\arcth}{arcth}
\newcommand{\dif}{\mathrm{d}}
\newcommand{\Indicator}[1]{\,\mathcal{I}\left\{#1\right\}}



% ------- Mathematical formatting -------
\renewcommand{\vec}{\bm}       % вектори
\newcommand{\mat}{\mathbf}     % матриці
\newcommand{\op}{\mathsf}      % оператори
\renewcommand{\kappa}{\varkappa}
\renewcommand{\geq}{\geqslant}
\renewcommand{\leq}{\leqslant}
\renewcommand{\int}{\varint}   % прямий інтеграл



% ------- Miscellaneous settings -------
\hfuzz 3pt \vfuzz 3pt             % Don't bother to report overfull h- and v-boxes < 3pt
\columnsep=0.4cm                  % multicol package: interval between columns
