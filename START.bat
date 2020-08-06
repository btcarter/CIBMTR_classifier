:: Preamble
:: Author - Benjamin Carter, PhD
:: Objective - start and pass arguments to an R script that will classify patients according to the CIBMTR guidelines
@echo off
cls

:: instructions and warnings
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo                             CIBMTR CLASSIFIER
echo                                version 0.1
echo                                 2020-08-06
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo.
echo Greetings human!
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
echo OBLIGATORY WARNING
echo The operating constraints of this particular program are very rigid. If
echo the Disease Tracker (excel workbook) varies too much from the template
echo then this script will crash and burn.
echo.
echo INSTRUCTIONS: You will be presented with a popup window to select the
echo Excel workbook of the patient you wish to classify. Select the workbook
echo and watch me go!
echo.
echo.
pause
echo How many patients do you want to classify?
echo (Please enter a whole number or 0 to exit)
SET /P var=

echo User entered %var%

if %var% EQU 1 (^
  :: this should start an R script if clicked on?
  "C:\Users\CarteB\OneDrive - BILLINGS CLINIC\Documents\R\R-4.0.2\bin\R.exe" ^
  CMD BATCH ^
  ".\classification.R"^
  ) ELSE (^
    IF %var% GTR 1 (^
      echo Master asks us to dos many, but Smeagol doesn't know hows it does it precious!
      echo User must hates us! Smeagol dies!
      ) ELSE (^
        IF %var% EQU 0 (^
          EXIT^
          )^
        )^
  )

timeout 2

echo finished!
