@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED Booking'
define root view entity YD1_CDS_DEMO2
  as select from yrap_demo2 as BookingDemo2
{
  key book_id as BookID,
  book_date as BookDate,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  booking_fee as BookingFee,
  currency_code as CurrencyCode,
  cust_name as CustName,
  city_from as CityFrom,
  city_to as CityTo,
  status as Status,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.lastChangedBy: true
  changed_by as ChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  changed_at as ChangedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  loc_changed_by as LocChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  loc_changed_at as LocChangedAt
  
}
