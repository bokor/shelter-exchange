module ReportsHelper
  
  def count_by_status
    Animal.count(:include => :animal_status, :select => "animal_statuses.name, count(animals.animal_status_id)",  :group => 'animal_status_id', :conditions => ['shelter_id = ?', @current_shelter.id ])
    # Animal.find(:all, 
    #   :select => "animal_statuses.name, count(animals.animal_status_id)", 
    #   :joins => :animal_status, 
    #   :group => "animal_statuses.id",
    #   :conditions => ['animals.shelter_id = ?', @current_shelter.id ])
    # Animal.find(:all, :include => [:animal_status], :select => "count(animals.animal_status_id) as count, animal_statuses.name as status")
    # Animal.count(:joins => :animal_status,
    #              :select => "count(animals.animal_status_id) as count, animal_statuses.name as status", 
    #              :conditions => ['animals.shelter_id = ?', @current_shelter.id ], 
    #              :group => 'animals.animal_status_id')
    # Animal.find(:all, 
    #             :select => "count(animals.animal_status_id)",
    #             :joins => :animal_status, 
    #             :conditions => {
    #               :animals =>{:shelter_id => @current_shelter.id}
    #             },
    #             :group => "animals.animal_status_id")
    # Animal.find( :all,
    #              :joins => :animal_status,
    #              :select => "count(animals.animal_status_id) as count, animal_statuses.name as status", 
    #              :conditions => ['animals.shelter_id = ?', @current_shelter.id ],
    #              :group => 'animals.animal_status_id' )
  end   
  
end

# SELECT     "animal_statuses".name, count(animal_status_id) as counter 
#   FROM      "animals"  INNER JOIN "animal_statuses" ON "animal_statuses"."id" = "animals"."animal_status_id" 
#   WHERE     (shelter_id = 123) 
# GROUP BY  animal_status_id 
# ORDER BY  created_at DESC
