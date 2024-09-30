-- Generated 1 insert statement

insert into lstsplfp (
  OPTION, OPTCMD, PROMPT, DESC
) values 
  ('PD', 'CPYSPLF FILE(&F) TOFILE(*TOSTMF) JOB(&J/&U/&N) SPLNBR(&S) TOSTMF(''/HOME/&U/&F_&J_&U_&N_&S.PDF'')', 'Y', 'Copy Spool File to PDF to HOME'),
  ('S', 'CHGSPLFA FILE(&F) JOB(&J/&U/&N) SPLNBR(&S) SAVE(*YES)', 'N', 'Save Spool File'),
  ('2', 'CHGSPLFA FILE(&F) JOB(&J/&U/&N) SPLNBR(&S)', 'Y', 'Change Spool File'),
  ('3', 'HLDSPLF FILE(&F) JOB(&J/&U/&N) SPLNBR(&S)', 'N', 'Hold Spool File'),
  ('4', 'DLTSPLF FILE(&F) JOB(&J/&U/&N) SPLNBR(&S)', 'N', 'Delete Spool File'),
  ('5', 'DSPSPLF FILE(&F) JOB(&J/&U/&N) SPLNBR(&S)', 'N', 'Display Spool File'),
  ('6', 'RLSSPLF FILE(&F) JOB(&J/&U/&N) SPLNBR(&S)', 'N', 'Release Spool File'),
  ('8', 'WRKSPLFA FILE(&F) JOB(&J/&U/&N) SPLNBR(&S)', 'N', 'Work Spool File Attributes'),
  ('XL', 'XLSSPLFPOI FILE(&F) JOB(&J/&U/&N) SPLNBR(&S)', 'Y', 'Convert Spool File to Excel');
