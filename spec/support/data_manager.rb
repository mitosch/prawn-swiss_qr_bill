# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module DataManager
  # rubocop:disable Metrics/MethodLength
  def self.build_bill(option = :default)
    bills = {}

    bills[:default] = {
      creditor: {
        iban: 'CH08 3080 8004 1110 4136 9',
        address: {
          name: 'Mischa Schindowski',
          line1: 'Schybenächerweg 553',
          line2: nil,
          postal_code: '5324',
          city: 'Full-Reuenthal',
          country: 'CH'
        }
      },
      debtor: {
        address: {
          name: 'Simon Muster',
          line1: 'Musterstrasse 1',
          line2: nil,
          postal_code: '8000',
          city: 'Zürich',
          country: 'CH'
        }
      },
      amount: 9.90,
      currency: 'CHF',
      reference: '00 00000 00000 02202 20202 99991',
      additional_information: "Auftrag vom 15.06.2020\n" \
                              "//S1/10/10201409/11/170309/20/14000000/\n" \
                              '30/106017086'
    }

    bills[:no_amount] = {
      creditor: {
        iban: 'CH08 3080 8004 1110 4136 9',
        address: {
          name: 'Mischa Schindowski',
          line1: 'Schybenächerweg 553',
          line2: nil,
          postal_code: '5324',
          city: 'Full-Reuenthal',
          country: 'CH'
        }
      },
      debtor: {
        address: {
          name: 'Simon Muster',
          line1: 'Musterstrasse 1',
          line2: nil,
          postal_code: '8000',
          city: 'Zürich',
          country: 'CH'
        }
      },
      currency: 'CHF',
      reference: '00 00000 00000 02202 20202 99991',
      additional_information: "Auftrag vom 15.06.2020\n" \
                              "//S1/10/10201409/11/170309/20/14000000/\n" \
                              '30/106017086'
    }

    bills[:no_reference] = {
      creditor: {
        iban: 'CH08 3080 8004 1110 4136 9',
        address: {
          name: 'Mischa Schindowski',
          line1: 'Schybenächerweg 553',
          line2: nil,
          postal_code: '5324',
          city: 'Full-Reuenthal',
          country: 'CH'
        }
      },
      debtor: {
        address: {
          name: 'Simon Muster',
          line1: 'Musterstrasse 1',
          line2: nil,
          postal_code: '8000',
          city: 'Zürich',
          country: 'CH'
        }
      },
      amount: 9.90,
      currency: 'CHF',
      additional_information: "Auftrag vom 15.06.2020\n" \
                              "//S1/10/10201409/11/170309/20/14000000/\n" \
                              '30/106017086'
    }

    bills[:no_additional_information] = {
      creditor: {
        iban: 'CH08 3080 8004 1110 4136 9',
        address: {
          name: 'Mischa Schindowski',
          line1: 'Schybenächerweg 553',
          line2: nil,
          postal_code: '5324',
          city: 'Full-Reuenthal',
          country: 'CH'
        }
      },
      debtor: {
        address: {
          name: 'Simon Muster',
          line1: 'Musterstrasse 1',
          line2: nil,
          postal_code: '8000',
          city: 'Zürich',
          country: 'CH'
        }
      },
      amount: 9.90,
      currency: 'CHF',
      reference: '00 00000 00000 02202 20202 99991'
    }

    bills[:no_debtor] = {
      creditor: {
        iban: 'CH08 3080 8004 1110 4136 9',
        address: {
          name: 'Mischa Schindowski',
          line1: 'Schybenächerweg 553',
          line2: nil,
          postal_code: '5324',
          city: 'Full-Reuenthal',
          country: 'CH'
        }
      },
      amount: 9.90,
      currency: 'CHF',
      reference: '00 00000 00000 02202 20202 99991'
    }

    bills[:no_debtor_ref] = {
      creditor: {
        iban: 'CH08 3080 8004 1110 4136 9',
        address: {
          name: 'Mischa Schindowski',
          line1: 'Schybenächerweg 553',
          line2: nil,
          postal_code: '5324',
          city: 'Full-Reuenthal',
          country: 'CH'
        }
      },
      amount: 9.90,
      currency: 'CHF'
    }

    bills[:no_debtor_ref_amount] = {
      creditor: {
        iban: 'CH08 3080 8004 1110 4136 9',
        address: {
          name: 'Mischa Schindowski',
          line1: 'Schybenächerweg 553',
          line2: nil,
          postal_code: '5324',
          city: 'Full-Reuenthal',
          country: 'CH'
        }
      },
      currency: 'CHF'
    }

    bills[:invalid_iban] = {
      creditor: {
        iban: 'CH08 3088 8004 1110 4136 9',
        #              ^ should be 0
        address: {
          name: 'Mischa Schindowski',
          line1: 'Schybenächerweg 553',
          line2: nil,
          postal_code: '5324',
          city: 'Full-Reuenthal',
          country: 'CH'
        }
      },
      debtor: {
        address: {
          name: 'Simon Muster',
          line1: 'Musterstrasse 1',
          line2: nil,
          postal_code: '8000',
          city: 'Zürich',
          country: 'CH'
        }
      },
      amount: 9.90,
      currency: 'CHF',
      reference: '00 00000 00000 02202 20202 99991',
      additional_information: "Auftrag vom 15.06.2020\n" \
                              "//S1/10/10201409/11/170309/20/14000000/\n" \
                              '30/106017086'
    }

    bills[option]
  end
  # rubocop:enable Metrics/MethodLength
end
# rubocop:enable Metrics/ModuleLength
