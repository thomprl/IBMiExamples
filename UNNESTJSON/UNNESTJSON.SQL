--https://stackoverflow.com/questions/63035346/db2-nested-json
Create Or Replace Function RTHOMPSON/unnest_json (
      p_doc Clob(1M)
      ,p_path Varchar(128)
    )
  Returns Table (
    index Int
    ,item Clob(1M)
  )
   NOT DETERMINISTIC
   SPECIFIC RTHOMPSON/UNNESTJSON
   EXTERNAL ACTION
   MODIFIES SQL DATA
   FENCED
   SET OPTION COMMIT = *NONE

  Return
    With items_array (items) As (
           Values
             Json_Object(
               Key 'items' Value Json_Query(p_doc, p_path) Format Json
             )
         )
         ,items (index, item) As (
           Select 0
                  ,Json_Query(items
                  ,'$.items[0]')
             From items_array
             Where Json_Exists (items, '$.items[0]')
           Union All
           Select i.index + 1
                  ,Json_Query(a.items
                  ,'$.items[' || Trim(i.index + 1) || ']')
             From items i
                  ,items_array a
             Where Json_Exists (a.items, '$.items[' || Trim(i.index + 1) || ']')
         ) Select index
                  ,item
      From items