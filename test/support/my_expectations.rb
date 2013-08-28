# coding: utf-8

module MyExpectations
   infect_an_assertion :assert_difference, :must_change
   infect_an_assertion :assert_no_difference, :wont_change

   infect_an_assertion :assert_redirected_to, :must_redirected_to
end

