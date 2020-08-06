:: Preamble
:: Author - Benjamin Carter, PhD
:: Objective - start and pass arguments to an R script that will classify patients according to the CIBMTR guidelines
@echo off
echo.
echo.
echo.
echo.
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo                             CIBMTR CLASSIFIER
echo                                version 0.1
echo                                 2020-08-06
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo.
echo Greetings human!
echo   O
echo  /|\
echo   |
echo  / \
echo.
echo This is a little program that will ingest an Excel workbook (Disease
echo Tracker), chew on it for a bit and then add the patient classifications to
echo it according to the CIBMTR guidelines.
echo.
echo This program follows the guidelines from the CIBMTR as published on the
echo date above. It is your responsibility to ensure they have not changed
echo between now and then. If they have then it is your responsibility to
echo contact the programmers and let them know a change is needed.
echo.
echo INSTRUCTIONS: You will be presented with a popup window to select the
echo Excel workbook of the patient you wish to classify. Select the workbook
echo and watch me go!
echo.
echo.
pause
:: this should start an R script if clicked on?
"C:\Users\CarteB\OneDrive - BILLINGS CLINIC\Documents\R\R-4.0.2\bin\R.exe" ^
CMD BATCH ^
"C:\Users\CarteB\OneDrive - BILLINGS CLINIC\projects\active\mmClassifier\classification.R"
echo.
echo finished!
