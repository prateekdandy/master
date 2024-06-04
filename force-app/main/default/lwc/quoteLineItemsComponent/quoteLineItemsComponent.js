import { LightningElement } from 'lwc';

export default class QuoteLineItemsComponent extends LightningElement {


    sortOptions = [
        { label: 'Sort Order', value: 'sort-order' },
        // Add other sort options here
      ];
    
      quoteLineItems = [
        // Sample quote line item data
        { id: 1, product: 'Monthly Minimum', salesPrice: 1000, discount: 0, totalPrice: 1000 },
        // Add more quote line items here
      ];
    
      fees = [
        // Sample fee data
        { id: 1, product: 'Activation Fee', salesPrice: 600, discount: 0, totalPrice: 600 },
        // Add more fees here
      ];
    
      equipments = [
        // Sample equipment data
        { id: 1, product: 'Trios 3', salesPrice: 0, discount: 0, totalPrice: 0 },
        // Add more equipment here
      ];
    
      coreProducts = [
        // Sample core products data
        { id: 1, product: 'Zirconia', salesPrice: 99, discount: 0, totalPrice: 99 },
        { id: 2, product: 'Night Guard', salesPrice: 109, discount: 0, totalPrice: 109 },
        { id: 3, product: 'Sports Guard', salesPrice: 109, discount: 0, totalPrice: 109 },
        // Add more equipment here
      ];

      detailProducts = [
        // Sample detail products data
        { id: 1, product: 'Clear Aligner Dual Arch 20', salesPrice: 99, discount: 0, totalPrice: 99 },
        { id: 2, product: 'Clear Aligner Dual Arch Max', salesPrice: 99, discount: 0, totalPrice: 99 },
        { id: 3, product: 'Dentures', salesPrice: 1099, discount: 0, totalPrice: 1099 },
        // Add more equipment here
      ];
}