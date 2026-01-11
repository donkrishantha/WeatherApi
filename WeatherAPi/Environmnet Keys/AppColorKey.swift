//
//  AppColorKey.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 25/12/2025.
//

import SwiftUI

struct AppLoadingKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

extension EnvironmentValues {
    var isAppLoading: Bool {
        get {
            self[AppLoadingKey.self]
        }
        set {
            self[AppLoadingKey.self] = newValue
        }
    }
}
//---------------------------------------

struct AppButtonTagKey: EnvironmentKey {
    static var defaultValue: ButtonTags = .Unknown
}

extension EnvironmentValues {
    var appButtonTag: ButtonTags {
        get {
            self[AppButtonTagKey.self]
        }
        set {
            self[AppButtonTagKey.self] = newValue
        }
    }
}

//----------------------------------------
struct AppButtonTagKeys: EnvironmentKey {
    static var defaultValue: MainModelButtonTags = .unknown
}

extension EnvironmentValues {
    var appButtonTags: MainModelButtonTags {
        get {
            self[AppButtonTagKeys.self]
        }
        set {
            self[AppButtonTagKeys.self] = newValue
        }
    }
}

//-----------------------------------
struct AppColorKey: EnvironmentKey {
    static var defaultValue: Color = .red
}

extension EnvironmentValues {
    var appColor: Color {
        get {
            self[AppColorKey.self]
        }
        set {
            self[AppColorKey.self] = newValue
        }
    }
}

//-------------------------------------
struct FSNumberKey: EnvironmentKey {
  static let defaultValue: Int = 5
}

extension EnvironmentValues {
  public var fsNumber: Int {
    get {
        self[FSNumberKey.self]
    }
    set {
        self[FSNumberKey.self] = newValue
    }
  }
}

//--------------------------------------
struct FSBoolBindingKey: EnvironmentKey {
  static var defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
  var fsBoolBinding: Binding<Bool> {
    get {
        self[FSBoolBindingKey.self]
    }
    set {
        self[FSBoolBindingKey.self] = newValue
    }
  }
}
