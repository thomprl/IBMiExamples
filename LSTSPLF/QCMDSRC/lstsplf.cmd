             CMD        PROMPT('Display Spool Files')
             PARM       KWD(USER) TYPE(*CHAR) LEN(10) +
                          DFT(*CURRENT) FILE(*UNSPFD) PROMPT('User')
             PARM       KWD(OUTQ) TYPE(*CHAR) LEN(10) DFT(*ALL) +
                          PROMPT('Output Queue')
             PARM       KWD(JOB) TYPE(QJOB) DFT(*ALL) SNGVAL((*ALL) +
                          (*)) PROMPT('Job name')
 QJOB:       QUAL       TYPE(*GENERIC) LEN(10) MIN(0)
             QUAL       TYPE(*GENERIC) LEN(10) SPCVAL((*ALL *ALL)) +
                          MIN(0) PROMPT('User')
             QUAL       TYPE(*CHAR) LEN(6) RANGE(000000 999999) +
                          SPCVAL((*ALL *ALL)) MIN(0) PROMPT('Number')
