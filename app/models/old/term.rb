class Term < ActiveRecord::Base
  ########################################### Summary ###############################################
  # Queries                                                                                         #
  # Class Methods                                                                                   #
  # Instance Methods                                                                                #
  # Object Builder                                                                                  #
  ###################################################################################################
  
  
  
  ########################################## Class Methods ##########################################
  # Summary of Term Class Methods:                                                                  #
  # null_all_current_terms                                                                          #
  def self.null_all_current_terms
      sql = <<__SQL__
UPDATE
  vistasupport.sel_terms
SET
  current_term = 'false'
__SQL__
      
      cursor = $vista_db_conn.parse(sql)
      response = cursor.exec
      $vista_db_conn.commit
      
      return response
    end # nullAllCurrentTerms
  ########################################## End Class Methods ######################################
  
  
  
  ########################################## Instance Methods #######################################
  # Summary of Term Instance Methods:                                                               #
  # delete                                                                                          #
  # update                                                                                          #
  # create                                                                                          #
  def delete
    sql = <<__SQL__
DELETE FROM 
  vistasupport.sel_terms 
WHERE
  term_id = :term_id
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':term_id', self.term_id)
    response = cursor.exec
    $vista_db_conn.commit
    
    return response
  end # delete
  
  def update
      sql = <<__SQL__
UPDATE
  vistasupport.sel_terms
SET
  term_id = :term_id,
  start_date = :start_date,
  end_date = :end_date,
  description = :description,
  current_term = :current_term
WHERE
  term_id = :old_term_id
__SQL__
      
      cursor = $vista_db_conn.parse(sql)
      cursor.bind_param(':old_term_id', self.old_term_id)
      cursor.bind_param(':term_id', self.term_id)
      cursor.bind_param(':start_date', self.start_date)
      cursor.bind_param(':end_date', self.end_date)
      cursor.bind_param(':description', self.description)
      cursor.bind_param(':current_term', self.current_term.to_s)
      response = cursor.exec
      $vista_db_conn.commit
      
      return response
    end # updateTermAttributes
    
    def create
      sql = <<__SQL__
INSERT INTO
  vistasupport.sel_terms (
    term_id,
    start_date,
    end_date,
    description,
    current_term
  )
VALUES (
  :term_id,
  :start_date,
  :end_date,
  :description,
  :current_term
)
__SQL__
      
      cursor = $vista_db_conn.parse(sql)
      cursor.bind_param(':term_id', self.term_id)
      cursor.bind_param(':start_date', self.start_date)
      cursor.bind_param(':end_date', self.end_date)
      cursor.bind_param(':description', self.description)
      cursor.bind_param(':current_term', self.current_term.to_s)
      response = cursor.exec
      $vista_db_conn.commit
      
      return response
    end # create
  ########################################## End Instance Methods ###################################
  
  
  
  ########################################## Queries ################################################
  # Summary of Term Queries:                                                                        #
  # find_irregular_terms                                                                            #
  # find_sso_terms                                                                                  #
  # find_term_by_term_id                                                                            #
  # find_current_term                                                                               #
  # find_future_terms                                                                               #
  # check_terms_existence                                                                           #
  # find_terms                                                                                      #
  def self.find_irregular_terms
    sql = <<__SQL__
SELECT
  lc_t.name "description",
  lc_t.source_id "term_id",
  y.start_date "start_date",
  y.end_date "end_date",
  y.current_term "current_term"
FROM
  webct.lc_term lc_t
LEFT OUTER JOIN
  (SELECT
    term_id, 
    start_date, 
    end_date,
    current_term
   FROM
    vistasupport.sel_terms) y
    ON y.term_id = lc_t.source_id
WHERE
  lc_t.source_id = 'group-term'
  OR lc_t.source_id = 'hidden-term'
  OR lc_t.source_id = 'preparea-term'
  OR lc_t.source_id = 'selfpaced-term'
  OR lc_t.source_id = 'specialprojects-term'
  OR lc_t.source_id = 'testing-term'
  OR lc_t.source_id = 'tlp-term'
ORDER BY
  lc_t.source_id
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.exec
    
    terms_ary = build_term_object(cursor)
    return terms_ary
  end # find_irregular_terms
  
  def self.find_sso_terms
    sql = <<__SQL__
SELECT
  lc_t.name "description",
  lc_t.source_id "term_id",
  y.start_date "start_date",
  y.end_date "end_date",
  y.current_term "current_term"
FROM
  webct.lc_term lc_t
LEFT OUTER JOIN
  (SELECT
    term_id, 
    start_date, 
    end_date,
    current_term
   FROM
    vistasupport.sel_terms) y
    ON y.term_id = lc_t.source_id
ORDER BY
  lc_t.source_id
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.exec
    
    term_ary = build_term_object(cursor)
    return term_ary
  end # find_sso_terms
  
  def self.find_term_by_term_id(term_id)
    sql = <<__SQL__
SELECT
  y.description "description",
  y.term_id "term_id",
  y.start_date "start_date",
  y.end_date "end_date",
  y.current_term "current_term"
FROM
  webct.lc_term lc_t
RIGHT OUTER JOIN
  (SELECT
    term_id, 
    start_date, 
    end_date,
    current_term,
    description
   FROM
    vistasupport.sel_terms) y
    ON y.term_id = lc_t.source_id
WHERE
  y.term_id = :term_id
ORDER BY
  lc_t.source_id
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':term_id', term_id)
    cursor.exec
    
    terms_ary = build_term_object(cursor)
    return terms_ary
  end # find_sso_term_by_term_id
  
  def self.find_current_term
    sql = <<__SQL__
SELECT
  st.term_id "term_id",
  st.start_date "start_date",
  st.end_date "end_date",
  st.description "description",
  st.current_term "current_term"
FROM
  vistasupport.sel_terms st
WHERE
  current_term = 'true'
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.exec
    
    terms_ary = build_term_object(cursor)
    return terms_ary
  end # find_current_term
  
  def self.find_future_terms
    sql = <<__SQL__
SELECT
  st.term_id "term_id",
  st.start_date "start_date",
  st.end_date "end_date",
  st.description "description",
  st.current_term "current_term"
FROM
  vistasupport.sel_terms st
JOIN
  (SELECT start_date FROM vistasupport.sel_terms WHERE current_term = 'true') y
ON
  st.start_date > y.start_date
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.exec
    
    terms_ary = build_term_object(cursor)
    return terms_ary
  end # find_future_terms
  
  def self.check_terms_existence(term_id, start_date, end_date)
    sql = <<__SQL__
SELECT
  st.term_id "term_id",
  st.start_date "start_date",
  st.end_date "end_date",
  st.description "description",
  st.current_term "current_term"
FROM
  vistasupport.sel_terms st
WHERE
  term_id = :term_id
  OR start_date = :start_date
  OR end_date = :end_date
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':term_id', term_id)
    cursor.bind_param(':start_date', start_date)
    cursor.bind_param(':end_date', end_date)
    cursor.exec
    
    terms_ary = build_term_object(cursor)
    if (terms_ary.empty?): return false else return true end
  end # find_terms_by_params
  
  def self.find_terms
    sql = <<__SQL__
SELECT
  st.term_id "term_id",
  st.start_date "start_date",
  st.end_date "end_date",
  st.description "description",
  st.current_term "current_term"
FROM
  vistasupport.sel_terms st
ORDER BY
  term_id DESC
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.exec
    
    terms_ary = build_term_object(cursor)
    return terms_ary
  end # find_terms
  ########################################## End Queries ############################################
  
  
  ########################################## Class Methods ##########################################
  def self.falsify_all_current_terms
    sql = <<__SQL__
UPDATE
  vistasupport.sel_terms
SET
  current_term = 'false'
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.exec
    $vista_db_conn.commit
  end # nullAllCurrentTerms
  ########################################## End Class Methods ######################################
  
  
  ########################################## Instance Methods #######################################
  # Summary of Instance Methods:                                                                    #
  # delete_term                                                                                     #
  # create_term                                                                                     #
  # update_term                                                                                     #
  def delete_term
    sql = <<__SQL__
DELETE FROM 
  vistasupport.sel_terms 
WHERE
  term_id = :term_id
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':term_id', self.term_id)
    cursor.exec
    $vista_db_conn.commit
  end # delete_term_by_term_id
  
  def create_term
    sql = <<__SQL__
INSERT INTO
  vistasupport.sel_terms (
    term_id,
    start_date,
    end_date,
    description,
    current_term
  )
VALUES (
  :term_id,
  :start_date,
  :end_date,
  :description,
  :current_term
)
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':term_id', self.term_id)
    cursor.bind_param(':start_date', self.start_date)
    cursor.bind_param(':end_date', self.end_date)
    cursor.bind_param(':description', self.description)
    cursor.bind_param(':current_term', self.current_term)
    cursor.exec
    $vista_db_conn.commit
  end # create_term
  
  def update_term
    sql = <<__SQL__
UPDATE
  vistasupport.sel_terms
SET
  term_id = :new_term_id,
  start_date = :start_date,
  end_date = :end_date,
  description = :description,
  current_term = :current_term
WHERE
  term_id = :term_id
__SQL__
    
    cursor = $vista_db_conn.parse(sql)
    cursor.bind_param(':term_id', self.term_id)
    cursor.bind_param(':new_term_id', self.new_term_id)
    cursor.bind_param(':start_date', self.start_date)
    cursor.bind_param(':end_date', self.end_date)
    cursor.bind_param(':description', self.description)
    cursor.bind_param(':current_term', self.current_term)
    response = cursor.exec
    $vista_db_conn.commit
  end # update_term
  ########################################## Instance Methods #######################################
  
  
  ########################################## Object Builder #########################################
  def self.build_term_object(cursor)
    term_ary = Array.new
    while rs_row = cursor.fetch_hash do
      term = Term.new
      term.old_term_id = rs_row['term_id']
      term.term_id = rs_row['term_id']
      term.start_date = rs_row['start_date']
      term.end_date = rs_row['end_date']
      if (rs_row['current_term'] == 'true')
        term.current_term = true
      else
        term.current_term = false
      end # if term.current_term
      term.description = rs_row['description']
      term_ary << term
    end # while rs_row
    return term_ary
  end # self.build_term_object
  ###################################### End Object Builder #########################################
end # class term