const t = require("./sum.js")
const assert = require("assert");

describe("Sum tests",()=>{
           
    it("sum",()=>{
        const result = t.sum(10,10)    
        assert(result,20)
    })
})

