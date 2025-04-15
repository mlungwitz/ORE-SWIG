/*
 Copyright (C) 2018, 2020 Quaternion Risk Management Ltd
 All rights reserved.

 This file is part of ORE, a free-software/open-source library
 for transparent pricing and risk analysis - http://opensourcerisk.org

 ORE is free software: you can redistribute it and/or modify it
 under the terms of the Modified BSD License.  You should have received a
 copy of the license along with this program.
 The license is also available online at <http://opensourcerisk.org>

 This program is distributed on the basis that it will form a useful
 contribution to risk analytics and model standardisation, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE. See the license for more details.
*/

#ifndef qle_coupons_i
#define qle_coupons_i

%include indexes.i
%include cashflows.i
%include scheduler.i

%{
using QuantExt::AverageONIndexedCoupon;
using QuantExt::CappedFlooredAverageONIndexedCoupon;
using QuantExt::CapFlooredAverageONIndexedCouponPricer;
using QuantExt::BlackAverageONIndexedCouponPricer;
using QuantExt::AverageONLeg;
//using QuantExt::OvernightIndexedCoupon;
using QuantExt::CappedFlooredOvernightIndexedCoupon;
using QuantExt::CappedFlooredOvernightIndexedCouponPricer;
using QuantExt::BlackOvernightIndexedCouponPricer;
//using QuantExt::OvernightLeg;
//using namespace std;
%}

%shared_ptr(AverageONIndexedCoupon)
class AverageONIndexedCoupon : public FloatingRateCoupon {
    public:
        AverageONIndexedCoupon(const Date& paymentDate, Real nominal, const Date& startDate, const Date& endDate,
                               const ext::shared_ptr<OvernightIndex>& overnightIndex, Real gearing = 1.0,
                               Spread spread = 0.0, Natural rateCutoff = 0, const DayCounter& dayCounter = DayCounter(),
                               const Period& lookback = 0 * Days, const Size fixingDays = Null<Size>(),
                               const Date& rateComputationStartDate = Null<Date>(),
                               const Date& rateComputationEndDate = Null<Date>(), const bool telescopicValueDates = false);

        const std::vector<QuantLib::Date>& fixingDates() const;
        const std::vector<Time>& dt() const;
        const std::vector<Rate>& indexFixings() const;
        const std::vector<Date>& valueDates() const;
        Natural rateCutoff() const;
        const Period& lookback() const;
        const Date& rateComputationStartDate() const;
        const Date& rateComputationEndDate() const;
        const ext::shared_ptr<OvernightIndex>& overnightIndex() const;
        Date fixingDate() const override;
};


%shared_ptr(CappedFlooredAverageONIndexedCoupon)
class CappedFlooredAverageONIndexedCoupon : public FloatingRateCoupon {
    public:
        CappedFlooredAverageONIndexedCoupon(const ext::shared_ptr<AverageONIndexedCoupon>& underlying,
                                            Real cap = Null<Real>(), Real floor = Null<Real>(), bool nakedOption = false,
                                            bool localCapFloor = false, bool includeSpread = false);
        bool isCapped() const;
        bool isFloored() const;

        ext::shared_ptr<AverageONIndexedCoupon> underlying() const;
        bool nakedOption() const;
        bool localCapFloor() const;
        bool includeSpread() const;
    
};

%shared_ptr(CapFlooredAverageONIndexedCouponPricer)
class CapFlooredAverageONIndexedCouponPricer : public FloatingRateCouponPricer {
	private:
		CapFlooredAverageONIndexedCouponPricer();
    public:
        Handle<OptionletVolatilityStructure> capletVolatility() const;
		bool effectiveVolatilityInput() const;
		Real effectiveCapletVolatility() const;   // only available after capletRate() was called
		Real effectiveFloorletVolatility() const; // only available after floorletRate() was called
};

%shared_ptr(BlackAverageONIndexedCouponPricer)
class BlackAverageONIndexedCouponPricer : public CapFlooredAverageONIndexedCouponPricer {
	public:
		BlackAverageONIndexedCouponPricer(const Handle<OptionletVolatilityStructure>& v,
                                           const bool effectiveVolatilityInput = false);
};

%shared_ptr(AverageONLeg)
class AverageONLeg {
    AverageONLeg(const Schedule& schedule, const ext::shared_ptr<OvernightIndex>& overnightIndex);
    AverageONLeg& withNotional(Real notional);
    AverageONLeg& withNotionals(const std::vector<Real>& notionals);
    AverageONLeg& withPaymentDayCounter(const DayCounter& dayCounter);
    AverageONLeg& withPaymentAdjustment(BusinessDayConvention convention);
    AverageONLeg& withGearing(Real gearing);
    AverageONLeg& withGearings(const std::vector<Real>& gearings);
    AverageONLeg& withSpread(Spread spread);
    AverageONLeg& withSpreads(const std::vector<Spread>& spreads);
    AverageONLeg& withTelescopicValueDates(bool telescopicValueDates);
    AverageONLeg& withRateCutoff(Natural rateCutoff);
    AverageONLeg& withPaymentCalendar(const Calendar& calendar);
    AverageONLeg& withPaymentLag(Natural lag);
    AverageONLeg& withLookback(const Period& lookback);
    AverageONLeg& withFixingDays(const Size fixingDays);
    AverageONLeg& withCaps(Rate cap);
    AverageONLeg& withCaps(const std::vector<Rate>& caps);
    AverageONLeg& withFloors(Rate floor);
    AverageONLeg& withFloors(const std::vector<Rate>& floors);
    AverageONLeg& includeSpreadInCapFloors(bool includeSpread);
    AverageONLeg& withNakedOption(const bool nakedOption);
    AverageONLeg& withLocalCapFloor(const bool localCapFloor);
    AverageONLeg& withInArrears(const bool inArrears);
    AverageONLeg& withLastRecentPeriod(const boost::optional<Period>& lastRecentPeriod);
    AverageONLeg& withLastRecentPeriodCalendar(const Calendar& lastRecentPeriodCalendar);
    AverageONLeg& withAverageONIndexedCouponPricer(const ext::shared_ptr<AverageONIndexedCouponPricer>& couponPricer);
    AverageONLeg& withCapFlooredAverageONIndexedCouponPricer(
        const ext::shared_ptr<CapFlooredAverageONIndexedCouponPricer>& couponPricer);
    operator Leg() const;
};

%rename(OvernightIndexedCouponExt) QuantExt::OvernightIndexedCoupon;
%shared_ptr(QuantExt::OvernightIndexedCoupon)
namespace QuantExt {
	class OvernightIndexedCoupon : public FloatingRateCoupon {
		public:
			OvernightIndexedCoupon(const Date& paymentDate, Real nominal, const Date& startDate, const Date& endDate,
							   const ext::shared_ptr<OvernightIndex>& overnightIndex, Real gearing = 1.0,
							   Spread spread = 0.0, const Date& refPeriodStart = Date(), const Date& refPeriodEnd = Date(),
							   const DayCounter& dayCounter = DayCounter(), bool telescopicValueDates = false,
							   bool includeSpread = false, const Period& lookback = 0 * Days, const Natural rateCutoff = 0,
							   const Natural fixingDays = Null<Size>(), const Date& rateComputationStartDate = Null<Date>(),
							   const Date& rateComputationEndDate = Null<Date>());
	};
}

%shared_ptr(CappedFlooredOvernightIndexedCoupon)
class CappedFlooredOvernightIndexedCoupon : public FloatingRateCoupon {
	public:
		CappedFlooredOvernightIndexedCoupon(const ext::shared_ptr<QuantExt::OvernightIndexedCoupon>& underlying,
											Real cap = Null<Real>(), Real floor = Null<Real>(), bool nakedOption = false,
											bool localCapFloor = false);
}; 

%shared_ptr(CappedFlooredOvernightIndexedCouponPricer)
class CappedFlooredOvernightIndexedCouponPricer : public FloatingRateCouponPricer {
	private:
		CappedFlooredOvernightIndexedCouponPricer();
	public:
		bool effectiveVolatilityInput() const;
		Real effectiveCapletVolatility() const;   // only available after capletRate() was called
		Real effectiveFloorletVolatility() const; // only available after floorletRate() was called												 
};

%shared_ptr(BlackOvernightIndexedCouponPricer)
class BlackOvernightIndexedCouponPricer : public CappedFlooredOvernightIndexedCouponPricer {
	public:
		BlackOvernightIndexedCouponPricer(const Handle<OptionletVolatilityStructure>& v,
                                              const bool effectiveVolatilityInput = false);
};

%rename(OvernightLegExt) QuantExt::OvernightLeg;
%shared_ptr(QuantExt::OvernightLeg)
namespace QuantExt {
	class OvernightLeg {
		OvernightLeg(const Schedule& schedule, const ext::shared_ptr<OvernightIndex>& overnightIndex);
		OvernightLeg& withNotionals(Real notional);
		OvernightLeg& withNotionals(const std::vector<Real>& notionals);
		OvernightLeg& withPaymentDayCounter(const DayCounter&);
		OvernightLeg& withPaymentAdjustment(BusinessDayConvention);
		OvernightLeg& withPaymentCalendar(const Calendar&);
		OvernightLeg& withPaymentLag(Natural lag);
		OvernightLeg& withGearings(Real gearing);
		OvernightLeg& withGearings(const std::vector<Real>& gearings);
		OvernightLeg& withSpreads(Spread spread);
		OvernightLeg& withSpreads(const std::vector<Spread>& spreads);
		OvernightLeg& withTelescopicValueDates(bool telescopicValueDates);
		OvernightLeg& includeSpread(bool includeSpread);
		OvernightLeg& withLookback(const Period& lookback);
		OvernightLeg& withRateCutoff(const Natural rateCutoff);
		OvernightLeg& withFixingDays(const Natural fixingDays);
		OvernightLeg& withCaps(Rate cap);
		OvernightLeg& withCaps(const std::vector<Rate>& caps);
		OvernightLeg& withFloors(Rate floor);
		OvernightLeg& withFloors(const std::vector<Rate>& floors);
		OvernightLeg& withNakedOption(const bool nakedOption);
		OvernightLeg& withLocalCapFloor(const bool localCapFloor);
		OvernightLeg& withInArrears(const bool inArrears);
		OvernightLeg& withLastRecentPeriod(const boost::optional<Period>& lastRecentPeriod);
		OvernightLeg& withLastRecentPeriodCalendar(const Calendar& lastRecentPeriodCalendar);
		OvernightLeg& withOvernightIndexedCouponPricer(const ext::shared_ptr<OvernightIndexedCouponPricer>& couponPricer);
		OvernightLeg& withPaymentDates(const std::vector<Date>& paymentDates);
		OvernightLeg& withCapFlooredOvernightIndexedCouponPricer(
			const ext::shared_ptr<CappedFlooredOvernightIndexedCouponPricer>& couponPricer);
		operator Leg() const;
	};
}
#endif