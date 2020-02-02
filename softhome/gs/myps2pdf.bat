"C:\Program Files\gs\bin\gswin64c" -q -P- -dSAFER -dNOPAUSE -dBATCH -dCompatibilityLevel=1.4 -sDEVICE=pdfwrite -sOutputFile=%~n1.pdf -c .setpdfwrite -f %1
