require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"

class Odnoklassnikizakaz < Test::Unit::TestCase

  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "localhost",
      :port => 4444,
      :browser => "*iexplore",
      :url => "http://new.socialgifts.ru/",
      :timeout_in_second => 60

    @selenium.start_new_browser_session
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_odnoklassnikizakaz
    @selenium.open "http://odnoklassniki.ru"
    @selenium.type "field_email", "boris.khodok@gmail.com"
    @selenium.type "field_password", "muzdetz1"
	@selenium.click "hook_FormButton_button_go"
	@selenium.wait_for_page_to_load "30000"
    @selenium.open "http://wishlist.odnoklassniki.ru"
	@selenium.wait_for_page_to_load "30000"
	@selenium.open "http://new.socialgifts.ru/welcome"
	@selenium.wait_for_page_to_load "30000"
    @selenium.click "//img[@alt='8']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//img[contains(@src,'http://static.socialgifts.ru/napoli_pictures/00/00/05/23/thumb.png')]"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "link=Купить"
    assert !60.times{ break if (@selenium.is_text_present("Оплатить наличными курьеру") rescue false); sleep 1 }
    @selenium.click "present_pay_cash_true"
    @selenium.type "user_email", "boris@gvfs.ru"
    @selenium.type "present_full_name", "Борис"
    @selenium.type "present_city", "Москваа"
	@selenium.type "present_address", "ул. 4-я 8-го Марта, 6А"
    @selenium.type "present_zipcode", "123654"
    @selenium.type "present_phone", "8 (495) 123-45-76"
    @selenium.type "present_note", "Проверка!"
    @selenium.click "link=Заказать"
    assert !60.times{ break if (@selenium.is_element_present("//section[@id='confirm_buying']/section[1]/h1") rescue false); sleep 1 }
    presentNumber = @selenium.get_text("//section[@id='confirm_buying']/section[1]/h4")
	presentNumber =~ /(\d+)/
	p $1
	@selenium.open "http://socialgifts.ru/operator/login"
    @selenium.type "operator_session_login", "boris@gvfs.ru"
    @selenium.type "operator_session_password", "4R834cjJAC"
    @selenium.click "operator_session_submit"
    @selenium.wait_for_page_to_load "30000"
	@selenium.open "http://socialgifts.ru/operator/presents/"+$1
	begin
        assert_equal "accepted", @selenium.get_text("//div[@id='container']/section/div[1]/p[6]/strong")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Отменить"
    begin
        assert @selenium.is_text_present("rejected")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
 #   begin
 #       assert_equal "rejected", @selenium.get_text("//div[@id='container']/section/div[1]/p[6]/strong")
 #   rescue Test::Unit::AssertionFailedError
 #       @verification_errors << $!
 #   end
  end
end
