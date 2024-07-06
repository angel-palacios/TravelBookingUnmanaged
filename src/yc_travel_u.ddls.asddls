@EndUserText.label: 'Travel Projection Unmanaged'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity YC_TRAVEL_U
  provider contract transactional_query
  as projection on YR_TRAVEL_U
{
  key TravelId,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{
          entity: {
              name: '/DMO/I_Agency',
              element: 'AgencyID'
          }}]
      @ObjectModel.text.element: ['AgencyName']
      AgencyId,
      _Agency.Name        as AgencyName,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{

         entity: {
             name: '/DMO/I_Customer',
             element: 'CustomerID'
         }}]
      @ObjectModel.text.element: ['CustomerName']
      CustomerId,
      _Customer.FirstName as CustomerName,
      BeginDate,
      EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{

      entity: {
          name: 'I_Currency',
          element: 'Currency'
      }}]
      CurrencyCode,
      Description,
      Status,
      Createdby,
      Createdat,
      Lastchangedby,
      Lastchangedat,
      /* Associations */
      _Agency,
      _Booking : redirected to composition child YC_BOOKING_U,
      _Currency,
      _Customer
}
