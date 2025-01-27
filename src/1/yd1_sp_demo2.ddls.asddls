@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for YD1_CDS_DEMO2'
@ObjectModel.semanticKey: [ 'BookID' ]
define root view entity YD1_SP_DEMO2
  provider contract transactional_query
  as projection on YD1_CDS_DEMO2
{
  key bookid,
  bookdate,
  bookingfee,
  currencycode,
  custname,
  cityfrom,
  cityto,
  status,
  locchangedat
  
}
