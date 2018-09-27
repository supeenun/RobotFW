*** Setting ***
Library             Selenium2Library

*** Variable ***
${URL_GOOGLE}     https://www.google.com/
${BROWSER}        chrome
${input_data}       //*[@id="lst-ib"]
${btn_search}        //*[@name="btnK"]

*** Keywords ***
Open Browser To Search Page
    Open Browser    ${URL_GOOGLE}    ${BROWSER}
    Maximize Browser Window


Search Page Should Be Open
    Input Text      ${input_data}   Test Framework

Submit Credentials
    Click Button      ${btn_search}

Please Wait Data
    Wait Until Page Contains      Test Framework


*** Test Cases ***
Search Google
    Open Browser To Search Page
    Search Page Should Be Open
    Submit Credentials
    Please Wait Data
        [Teardown]    Close Browser

