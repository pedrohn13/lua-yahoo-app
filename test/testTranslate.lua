require "lunit"
require "translateDate"

module( "categoryTranslateTest", package.seeall, lunit.testcase )

function test_TranslateDayOfMonth()
	assert_equal("01 Jan 2012",translateDayOfMonth("01 Jan 2012"))
	assert_equal("01 Fev 2012",translateDayOfMonth("01 Feb 2012"))
	assert_equal("01 Mar 2012",translateDayOfMonth("01 Mar 2012"))
	assert_equal("01 Abr 2012",translateDayOfMonth("01 Apr 2012"))
	assert_equal("01 Mai 2012",translateDayOfMonth("01 May 2012"))
	assert_equal("01 Jun 2012",translateDayOfMonth("01 Jun 2012"))
	assert_equal("01 Jul 2012",translateDayOfMonth("01 Jul 2012"))
	assert_equal("01 Ago 2012",translateDayOfMonth("01 Aug 2012"))
	assert_equal("01 Set 2012",translateDayOfMonth("01 Sep 2012"))
	assert_equal("01 Out 2012",translateDayOfMonth("01 Oct 2012"))
	assert_equal("01 Nov 2012",translateDayOfMonth("01 Nov 2012"))
	assert_equal("01 Dez 2012",translateDayOfMonth("01 Dec 2012"))
end

