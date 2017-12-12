#!/bin/bash -e

file=WellerSSnotes

if [ -e ${file}.pdf ]; then
    rm ${file}.pdf
fi

# create the online version
sed 's/%VERSION/\\onlineversion\\studentversion/g' studentVersionTMP > studentVersion.tex
lyx --export pdflatex -f all ${file}.lyx
sed -i 's/mathptmx/mathptmx,newtxmath/g' WellerSSnotes.tex
pdflatex ${file}.tex
pdflatex ${file}.tex
mv ${file}.pdf ${file}_online.pdf

# create the students version
sed 's/%VERSION/\\studentversion/g' studentVersionTMP > studentVersion.tex
lyx --export pdflatex -f all ${file}.lyx
sed -i 's/mathptmx/mathptmx,newtxmath/g' WellerSSnotes.tex
pdflatex ${file}.tex
pdflatex ${file}.tex
pdfjam --nup 1x2 --scale 0.95 --a4paper $file.pdf --outfile ${file}_2_student.pdf

# create the lecturers version
cp studentVersionTMP studentVersion.tex
lyx --export pdflatex -f all ${file}.lyx
sed -i 's/mathptmx/mathptmx,newtxmath/g' WellerSSnotes.tex
pdflatex ${file}.tex
pdflatex ${file}.tex
pdfjam --nup 1x2 --scale 0.95 --a4paper $file.pdf --outfile ${file}_2_lec.pdf

rmtexall ${file}.tex
rm $file.pdf

#okular *pdf &

## tar and gzip the necessary stuff
#tar cvf - *pdf animations practicals/linearAdvectCode/ practicals/SWE \
#    | gzip -c > Weller_summerSchool.tar.gz

scp WellerSSnotes_*.pdf $OAK:public_html/teaching

