struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
// create a Money type (a struct)
// three methods: convert, add, subtract
public struct Money {
    public let amount: Int
    public let currency: String
    
    
    private static let exchangeRates: [String: Double] = [
        "USD": 1.0,
        "GBP": 0.5,
        "EUR": 1.5,
        "CAN": 1.25
    ]
    
    public init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    public func convert(_ value: String) -> Money {
        guard
            let initial = Money.exchangeRates[self.currency],
            let final = Money.exchangeRates[value]
        else {
            fatalError("error!")
        }
        // normalize through USD
        let dollars = Double(self.amount) / initial
        let converted = Int((dollars * final).rounded())
        
        return Money(amount: converted, currency: value)
    }
    
    public func add(_ value: Money) -> Money {
        let convertedSelf = self.convert(value.currency)
        return Money(
            amount: convertedSelf.amount + value.amount,
            currency: value.currency
        )
    }
    
    public func subtract(_ value: Money) -> Money {
        let convertedSelf = self.convert(value.currency)
        return Money(
            amount: convertedSelf.amount - value.amount,
            currency: value.currency
        )
    }
}

//////////////////////////////////////
////// Job
//
//The two methods you must provide are:
//* `calculateIncome`, which returns the amount of money (as an Integer, we're not worried about Money here) that this position makes in a calendar year. For Salary positions, this is simply the yearly amount; for Hourly positions, this is the hourly amount multiplied by 2000. (Interesting and important note for job seekers: assuming you get two weeks' off during the year, there are 50 weeks * 40 hours/week, or 2000 working hours in a given calendar year.)
//* `raise`, which should bump the amount of the Salary or the Hourly by the given amount, and/or by the given percentage. (In other words, `raise` should be overloaded by parameter name.)

public class Job {
    public let title: String
    public var type: JobType

    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    public init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    public func calculateIncome(_ hours: Int) -> Int {
        switch type {
            case .Salary(let salary):
                return Int(salary)
            case .Hourly(let rate):
                return Int(rate * Double(hours))
        }
    }
    
    // raise should be overloaded by parameter name!!!!
    public func raise(byAmount amount: Double) {
        switch type {
            case .Salary(let salary):
                type = .Salary(UInt(Double(salary) + amount))
            case .Hourly(let rate):
                type = .Hourly(rate + amount)
        }
    }

    // and/or percentage raise...
    public func raise(byPercent percent: Double) {
        let multiplier = percent + 1
        switch type {
            case .Salary(let salary):
                type = .Salary(UInt(Double(salary) * multiplier))
            case .Hourly(let rate):
                type = .Hourly(rate * multiplier)
        }
    }
}
//
//////////////////////////////////////
//// Person
////

//
//Create a method to display a human-readable String of the contents of a Person. (Since so many of you--and me--are all comfortable with Java, call it `toString`.) Put some reasonable display of the Person class there, along the lines of `[Person: firstName: Ted lastName: Neward age: 45 job: Salary(1000) spouse: Charlotte]`.
public class Person {
    public let firstName: String
    public let lastName: String
    public let age: Int
    
    public var job: Job? {
           didSet {
               // Must be at least 16 to have a job
               if age < 16 {
                   job = nil
               }
           }
       }
    
    public var spouse: Person? {
        didSet {
            if age < 18 {
                spouse = nil
            }
            
        }
    }
    
    public init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    public func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job == nil ? "nil" : "Job") spouse:\(spouse == nil ? "nil" : spouse!.firstName)]"
    }
}

    
    
    
    
//////////////////////////////////////
//// Family
public class Family {
    public var members: [Person]

    public init(spouse1: Person, spouse2: Person) {
        // can't be married more than once at the same time
        guard spouse1.spouse == nil && spouse2.spouse == nil else {
            fatalError("currently married more than once.")
        }

        spouse1.spouse = spouse2
        spouse2.spouse = spouse1

        self.members = [spouse1, spouse2]
    }
    
    public func haveChild(_ child: Person) -> Bool {
        var canHaveChild = false
        for person in members {
            if person.age >= 21 {
                canHaveChild = true
                break
            }
        }
        if canHaveChild {
               members.append(child)
           }
        return canHaveChild
    }
    
    public func householdIncome() -> Int {
        var totalIncome = 0

        for person in members {
            if let job = person.job {
                totalIncome += job.calculateIncome(2000)
            }
        }

        return totalIncome
    }
}
