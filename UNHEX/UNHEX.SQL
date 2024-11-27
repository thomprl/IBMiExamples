CREATE FUNCTION RTHOMPSON/UNHEX (          
  "IN" VARCHAR(32000) FOR BIT DATA )  
  RETURNS VARCHAR(32000)              
  LANGUAGE SQL                        
  SPECIFIC RTHOMPSON/UNHEX                 
  DETERMINISTIC                       
  CONTAINS SQL                        
  CALLED ON NULL INPUT                
  NO EXTERNAL ACTION                  
  SET OPTION  ALWBLK = *ALLREAD ,     
  ALWCPYDTA = *OPTIMIZE ,             
  COMMIT = *CHG ,                     
  DECRESULT = (31, 31, 00) ,          
  DYNDFTCOL = *NO ,                   
  DYNUSRPRF = *USER ,                 
  SRTSEQ = *HEX                       
  BEGIN ATOMIC                        
RETURN IN ;                           
END  ;                                