//
//  ContentView.swift
//  CoreDataHelper
//
//  Created by Panbers on 20/12/20.
//

import SwiftUI

struct ContentView: View {
  
  var body: some View {
    HomeView()
  }
}

struct HomeView: View {
  @Environment(\.managedObjectContext) var context
  @FetchRequest(
    entity: CartData.entity(),
    sortDescriptors: []) var cartData: FetchedResults<CartData>
  let helperData = HelperData()
  
  var body: some View {
    NavigationView {
      ZStack {
        VStack {
          List {
            ForEach(cartData){ data in
              VStack(alignment: .leading) {
                HStack {
                  Text(data.name ?? "")
                  Spacer()
                  Image(systemName: "trash.fill")
                    .imageScale(.medium)
                    .foregroundColor(Color.red)
                    .onTapGesture {
                      helperData.deleteCart(context: context, item: data)
                    }
                }
                HStack {
                  HStack {
                    Text("Total")
                    Text("\(data.total)")
                  }
                  Spacer()
                  HStack {
                    Image(systemName: "minus.circle.fill")
                      .foregroundColor(data.jumlah > 1 ? Color.red : Color.gray)
                      .disabled(data.jumlah < 1 ? true : false)
                      .onTapGesture {
                        if data.jumlah > 1 {
                          helperData.minusOneItem(context: context, item: data)
                        }
                      }
                    Text("\(data.jumlah)")
                    Image(systemName: "plus.circle.fill")
                      .foregroundColor(Color.blue)
                      .onTapGesture {
                        helperData.plusOneItem(context: context, item: data)
                      }
                  }
                }
                .padding(.top, 10)
              }
            }
          }
          
          Spacer()
          
          NavigationLink(destination: NestedView()) {
            Text("Navigate to nested tab 1")
              .foregroundColor(Color.black)
          }
        }
      }
      .navigationTitle("Cart Data")
      .navigationBarItems(trailing: Button("Add Cart") {
        helperData.addCart(context: context)
      })
    }
  }
}

struct NestedView: View {
  @Environment(\.managedObjectContext) var context
  @FetchRequest(
    entity: CartData.entity(),
    sortDescriptors: []) var cartData: FetchedResults<CartData>
  @ObservedObject var helperData = HelperData()
  @State var totalOrder = 0
  
  var body: some View {
    ZStack {
      VStack {
        if cartData.count == 0 {
          Text("Empty Cart")
            .foregroundColor(Color.red)
        }
        
        List {
          ForEach(cartData){ data in
            VStack(alignment: .leading) {
              HStack {
                Text(data.name ?? "")
                Spacer()
                Image(systemName: "trash.fill")
                  .imageScale(.medium)
                  .foregroundColor(Color.red)
                  .onTapGesture {
                    helperData.deleteCart(context: context, item: data)
                  }
              }
              HStack {
                HStack {
                  Text("Total")
                  Text("\(data.total)")
                }
                Spacer()
                HStack {
                  Image(systemName: "minus.circle.fill")
                    .foregroundColor(data.jumlah > 1 ? Color.red : Color.gray)
                    .disabled(data.jumlah < 1 ? true : false)
                    .onTapGesture {
                      if data.jumlah > 1 {
                        helperData.minusOneItem(context: context, item: data)
                      }
                    }
                  Text("\(data.jumlah)")
                  Image(systemName: "plus.circle.fill")
                    .foregroundColor(Color.blue)
                    .onTapGesture {
                      helperData.plusOneItem(context: context, item: data)
                    }
                }
              }
              .padding(.top, 10)
            }
          }
        }
        
        Spacer()
        
        if cartData.count > 0 {
          HStack {
            VStack(alignment: .leading) {
              Text("Total Order")
              Text("\(totalOrder)")
            }
            Spacer()
            Button(action: {
              helperData.deleteAllCart(context: context)
            }) {
              HStack {
                Image(systemName: "trash.fill")
                  .imageScale(.medium)
                  .foregroundColor(Color.red)
                Text("Delete All")
                  .foregroundColor(Color.red)
              }
            }
          }
          .padding()
        }
        
      }
    }
    .onChange(of: helperData.loadTotal) { newValue in
      if newValue {
        loadTotal()
        self.helperData.loadTotal = false
      }
    }
    .onAppear(perform: {
      loadTotal()
    })
  }
  
  private func loadTotal() {
    var total = 0
    for item in cartData {
      total += Int(item.total)
    }
    self.totalOrder = total
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
