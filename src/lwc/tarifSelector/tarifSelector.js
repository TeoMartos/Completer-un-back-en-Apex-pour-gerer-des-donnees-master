/**
 * Created by TMARTOS on 07/04/2025.
 */

import {
    LightningElement,
    api,
    wire,
    track
} from 'lwc';
import getLivraison from '@salesforce/apex/TarifController.getLivraisonById';
import getAccount from '@salesforce/apex/AccountSelector.getAccountById';
import getTarifs from '@salesforce/apex/TarifSelector.getTarifsByZoneName';

export default class TarifSelector extends LightningElement {
    @api recordId; // ID de la livraison
    @track tarifs = [];
    @track selectedTarifId;
    @track error;
    @track hasTarif = false;
    @track showTarifs = false;

    zoneName;
    typeName;

    columns = [
        {
            label: 'Tarif',
            fieldName: 'tarif',
            type: 'currency',
            typeAttributes: {
                currencyCode: 'EUR',
                step: '0.01'
            }
        },
        {
            label: 'Transporteur',
            fieldName: 'transporteurName',
            type: 'text'
        },
        {
            label: 'Zone de Livraison',
            fieldName: 'zoneName',
            type: 'text'
        },
        {
            label: 'Délai de Livraison',
            fieldName: 'delaiLivraison',
            type: 'number',
            typeAttributes: {
                minimumFractionDigits: 0,
                maximumFractionDigits: 0
            }
        },
        {
            type: 'action',
            typeAttributes: {
                rowActions: [{
                    label: 'Sélectionner',
                    name: 'select'
                }]
            }
        }
    ];

    connectedCallback() {
        console.log('[TarifSelector] ✅ connectedCallback - recordId (Livraison) :', this.recordId);
    }

    @wire(getLivraison, { livraisonId: '$recordId' })
    wiredLivraison({ data, error }) {
        console.log('[TarifSelector] 🔄 wire getLivraison - recordId utilisé :', this.recordId);
        if (data) {
            console.log('[TarifSelector] ✅ Livraison récupérée :', JSON.stringify(data));
            const orderId = data.Commande__c;
            const accountId = data.Commande__r.AccountId;
            console.log('[TarifSelector] 📦 Commande ID:', orderId, '| Compte ID:', accountId);

            getAccount({ accountId: accountId })
                .then(acc => {
                    console.log('[TarifSelector] ✅ Compte récupéré :', JSON.stringify(acc));
                    this.zoneName = acc.ShippingCountry;
                    this.typeName = acc.Acc_TypeClient__c;
                    console.log('[TarifSelector] 📦 zoneName:', this.zoneName, '| typeName:', this.typeName);

                    return getTarifs({ zoneName: this.zoneName, typeName: this.typeName });
                })
                .then(result => {
                    console.log('[TarifSelector] 📦 Résultat getTarifs:', JSON.stringify(result));
                    this.hasTarif = result.length > 0;
                    this.tarifs = result.map(item => ({
                        id: item.Id,
                        tarif: item.Tarif__c,
                        transporteurName: item.Transporteur__r.Name,
                        zoneName: item.Zone_de_Livraison__r.Name,
                        delaiLivraison: item.Delai_Livraison__c
                    }));
                    this.error = null;
                })
                .catch(error => {
                    console.error('[TarifSelector] ❌ Erreur lors du traitement :', error);
                    this.error = 'Erreur lors du traitement des données.';
                });

        } else if (error) {
            console.error('[TarifSelector] ❌ Erreur lors de la récupération de la livraison :', JSON.stringify(error));
            this.error = 'Impossible de charger la livraison.';
        }
    }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;

        if (action.name === 'select') {
            this.selectedTarifId = row.id;
            const selectEvent = new CustomEvent('tarifselected', {
                detail: {
                    tarifId: row.id
                }
            });
            this.dispatchEvent(selectEvent);
        }
    }

    handleClick() {
        this.showTarifs = true;
        console.log('[TarifSelector] 👇 Bouton cliqué - affichage des tarifs demandé');
    }
}
