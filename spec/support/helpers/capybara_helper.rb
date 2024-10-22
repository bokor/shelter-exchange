module CapybaraHelper

  def page_title_should_be(title)
   expect(find("h1").text).to eq(title)
  end

  def flash_message_should_be(message)
    within "#flash_messages" do
      expect(page).to have_content message
    end
  end

  def body_class_should_include(action_and_controller)
    expect(find("body")[:class]).to include(action_and_controller)
  end

  def calendar_datepicker_from(element, timeframe=:current_month)
    page.execute_script %Q{ $('#{element}').trigger("focus") } # activate datetime picker

    case timeframe
    when :previous_month
      page.execute_script %Q{ $('a.ui-datepicker-prev').trigger("click") } # move one month previous
    when :next_month
      page.execute_script %Q{ $('a.ui-datepicker-next').trigger("click") } # move one month forward
    end

    page.execute_script %Q{ $("a.ui-state-default:contains('15')").trigger("click") } # click on day 15
  end

  def accept_confirmation!
    page.driver.browser.switch_to.alert.accept
  end

  def reject_confirmation!
    page.driver.browser.switch_to.alert.dismiss
  end

  def mouse_over element
    element = find(element) if String === element
    page.driver.browser.mouse.move_to element.native
  end
end
