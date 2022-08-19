//
//  Country.swift
//  TikQuiz
//
//  Created by István Kreisz on 8/6/22.
//

import Foundation

enum Country: String, Codable, CaseIterable, Equatable {
    case ALB
    case AND
    case ARE
    case ARG
    case ASM
    case AUS
    case AUT
    case BEL
    case BGD
    case BGR
    case BLR
    case BMU
    case BRA
    case BTN
    case BWA
    case CAN
    case CHE
    case CHL
    case COL
    case CZE
    case DEU
    case DNK
    case DOM
    case ECU
    case ESP
    case EST
    case FIN
    case FRA
    case FRO
    case GBR
    case GHA
    case GRC
    case GTM
    case HRV
    case HUN
    case IDN
    case IND
    case IRL
    case ISL
    case ISR
    case ITA
    case JOR
    case JPN
    case KEN
    case KGZ
    case KHM
    case KOR
    case LAO
    case LKA
    case LSO
    case LTU
    case LUX
    case LVA
    case MEX
    case MLT
    case MNE
    case MNG
    case MYS
    case NGA
    case NLD
    case NOR
    case NZL
    case PER
    case PHL
    case POL
    case PRT
    case ROU
    case RUS
    case SEN
    case SGP
    case SMR
    case SRB
    case SVK
    case SVN
    case SWE
    case SWZ
    case THA
    case TUN
    case TUR
    case TWN
    case UGA
    case UKR
    case URY
    case USA
    case VNM
    case ZAF

    var name: String {
        switch self {
        case .ALB: return "Albania"
        case .AND: return "Andorra"
        case .ARE: return "United Arab Emirates"
        case .ARG: return "Argentina"
        case .ASM: return "American Samoa"
        case .AUS: return "Australia"
        case .AUT: return "Austria"
        case .BEL: return "Belgium"
        case .BGD: return "Bangladesh"
        case .BGR: return "Bulgaria"
        case .BLR: return "Belarus"
        case .BMU: return "Bermuda"
        case .BRA: return "Brazil"
        case .BTN: return "Bhutan"
        case .BWA: return "Botswana"
        case .CAN: return "Canada"
        case .CHE: return "Switzerland"
        case .CHL: return "Chile"
        case .COL: return "Colombia"
        case .CZE: return "Czech Republic"
        case .DEU: return "Germany"
        case .DNK: return "Denmark"
        case .DOM: return "Dominican Republic"
        case .ECU: return "Ecuador"
        case .ESP: return "Spain"
        case .EST: return "Estonia"
        case .FIN: return "Finland"
        case .FRA: return "France"
        case .FRO: return "Faroe Islands"
        case .GBR: return "United Kingdom"
        case .GHA: return "Ghana"
        case .GRC: return "Greece"
        case .GTM: return "Guatemala"
        case .HRV: return "Croatia"
        case .HUN: return "Hungary"
        case .IDN: return "Indonesia"
        case .IND: return "India"
        case .IRL: return "Ireland"
        case .ISL: return "Iceland"
        case .ISR: return "Israel"
        case .ITA: return "Italy"
        case .JOR: return "Jordan"
        case .JPN: return "Japan"
        case .KEN: return "Kenya"
        case .KGZ: return "Kyrgyzstan"
        case .KHM: return "Cambodia"
        case .KOR: return "South Korea"
        case .LAO: return "Laos"
        case .LKA: return "Sri Lanka"
        case .LSO: return "Lesotho"
        case .LTU: return "Lithuania"
        case .LUX: return "Luxembourg"
        case .LVA: return "Latvia"
        case .MEX: return "Mexico"
        case .MLT: return "Malta"
        case .MNE: return "Montenegro"
        case .MNG: return "Mongolia"
        case .MYS: return "Malaysia"
        case .NGA: return "Nigeria"
        case .NLD: return "Netherlands"
        case .NOR: return "Norway"
        case .NZL: return "New Zealand"
        case .PER: return "Peru"
        case .PHL: return "Philippines"
        case .POL: return "Poland"
        case .PRT: return "Portugal"
        case .ROU: return "Romania"
        case .RUS: return "Russia"
        case .SEN: return "Senegal"
        case .SGP: return "Singapore"
        case .SMR: return "San Marino"
        case .SRB: return "Serbia"
        case .SVK: return "Slovakia"
        case .SVN: return "Slovenia"
        case .SWE: return "Sweden"
        case .SWZ: return "Swaziland"
        case .THA: return "Thailand"
        case .TUN: return "Tunisia"
        case .TUR: return "Turkey"
        case .TWN: return "Taiwan"
        case .UGA: return "Uganda"
        case .UKR: return "Ukraine"
        case .URY: return "Uruguay"
        case .USA: return "United States"
        case .VNM: return "Vietnam"
        case .ZAF: return "South Africa"
        }
    }
}
