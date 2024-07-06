@EndUserText.label: 'Booking Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define view entity YC_BOOKING_U
  as projection on YI_Booking_U
{
      @Search.defaultSearchElement: true
  key TravelID,
      @Search.defaultSearchElement: true
  key BookingID,
      BookingDate,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{
      entity: {
          name: '/DMO/I_Customer',
          element: 'CustomerID'
      }}]
      @ObjectModel.text.element: ['CustomerName']
      CustomerID,
      _Customer.FirstName as CustomerName,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{

      entity: {
       name: '/DMO/I_Carrier',
       element: 'AirlineID'
      }}]
      @ObjectModel.text.element: ['AirlineName']
      AirlineID,
      _Carrier.Name       as AirlineName,
      @Consumption.valueHelpDefinition: [{
      entity: {
      name: '/DMO/I_Flight',
      element: 'ConnectionID'
      },
      additionalBinding: [
      {localElement: 'FlightDate', element: 'FlightDate'},
      {localElement: 'AirlineID',element: 'AirlineID' },
      {localElement: 'FlightPrice',element: 'Price'},
      {localElement: 'CurrencyCode',element: 'CurrencyCode'}]
      }]
      ConnectionID,
      @Consumption.valueHelpDefinition: [{
      entity: {
         name: '/DMO/I_Flight',
         element: 'FlightDate'
      },
      additionalBinding: [
         {localElement: 'ConnectionID', element: 'ConnectionID'},
         {localElement: 'AirlineID',element: 'AirlineID' },
         {localElement: 'FlightPrice',element: 'Price'},
         {localElement: 'CurrencyCode',element: 'CurrencyCode'}]
      }]
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      @Consumption.valueHelpDefinition: [{
      entity: {
      name: 'I_Currency',
      element: 'Currency'
      }}]
      CurrencyCode,
      /* Associations */
      _Carrier,
      _Connection,
      _Customer,
      _Travel : redirected to parent YC_TRAVEL_U
}
