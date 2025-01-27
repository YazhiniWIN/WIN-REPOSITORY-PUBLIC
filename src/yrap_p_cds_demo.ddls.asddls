@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection CDS'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity YRAP_P_CDS_DEMO
  provider contract transactional_query
  as projection on YRAP_I_CDS_DEMO
{
      @EndUserText.label: 'Booking Id'
  key bookId,
      bookDate,
      @Semantics.amount.currencyCode: 'amount'
      bookFee,
      amount,
      custName,           
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Country', element: 'Country' } }]
      source,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Country', element: 'Country' } }]
      destination,
      status,
      inactive,

      created_by,
      changed_by,
      created_at,
      changed_at
}
