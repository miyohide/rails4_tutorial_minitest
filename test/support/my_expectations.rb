# coding: utf-8

module MyExpectations
   infect_an_assertion :assert_difference, :must_change
   infect_an_assertion :assert_no_difference, :wont_change
end

