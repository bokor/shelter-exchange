class AnimalPdf < Prawn::Document
  def initialize(animal, notes, shelter, params, view)
    super(top_margin: 70)
    @animal = animal
    @notes = notes
    @shelter = shelter
    @view = view
    send(params[:print_layout])
  end
  
  private
  
  def animal_with_notes
    order_number("animal_with_notes")
    line_items unless @notes.blank?
  end
  
  def kennel_card
    order_number("kennel_card")
    line_items unless @notes.blank?
  end
  
  
  
  
  def order_number(test)
    text "Animal \##{@animal.name} #{test}", size: 30, style: :bold
    float do
        move_down 50
        bounding_box [0, cursor], :width => 100 do
          text "Text written inside the float block."
          stroke_bounds
        end
      end
  end
  
  def line_items
    move_down 20
    table line_item_rows do
      row(0).font_style = :bold
      columns(1..3).align = :right
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end
  
  def line_item_rows
    [["Category", "Title"]] +
    @notes.map do |note|
      [note.category, note.title]
    end
  end
  # 
  # def price(num)
  #   @view.number_to_currency(num)
  # end
  # 
  # def total_price
  #   move_down 15
  #   text "Total Price: #{price(@order.total_price)}", size: 16, style: :bold
  # end
end