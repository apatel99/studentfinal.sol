pragma solidity ^0.5.1;

contract Student
{
    struct student{
        string name;
        uint id;
        address student;
        string course;
        
        
    }
    mapping(address => bool) feespaid;
    mapping(address => uint) feesamount;
    student[]  public studentList;
    
    uint studentcount;
    address registrar;
    event registered(address studentaddr, uint fees);
    
    constructor(address _owner) public
    {
        registrar=_owner;
        studentcount =0;
    }
    modifier onlyRegistrar()
    {
        require(tx.origin==registrar);
        _;
    }

   function Register(string memory _name,uint _id,address _student,string memory _course) public onlyRegistrar
   {
       studentList.push(student(_name,_id,_student,_course));
       studentcount++;
       
   }
   
   function Payfees(address _student)public payable
   {
       require(msg.value==1 ether);
       feespaid[_student]=true;
       feesamount[_student]=msg.value;
       
       emit registered(_student,msg.value);
   }
   function checkfees(address _student) private view returns(uint)
   {
       return feesamount[_student];
   }
   function callcheckfees(address _student) public view returns(uint)
   {
       uint amount=feesamount[_student];
       return amount;
       
   }
    
}

contract Factory {
    
    uint public studentId;
    
    mapping(uint =>Student) studentList;
    
    event NewStudent(uint id );
    
    function deployStudent(address _owner) public {
        studentId++;
       Student s= new Student(_owner);
       studentList[studentId] = s;
        emit NewStudent(studentId);
    }
    
    function getstudentById(uint _id) public view returns (Student) {
       return studentList[_id];
    }
}


contract Dashboard
{
    Factory database;
      
      constructor(address _database) public {
        database = Factory(_database);
    }
    
     function NewStudent(address _owner) public  {
        database.deployStudent(_owner);
    }
    function getRegisterbyId(uint _id,string memory _name,uint studentid,address _student,string memory _cours) public  {
        Student s= Student(database.getstudentById(_id));
      s.Register(_name,studentid,_student,_cours);
       
       
    }
    function getPayFeesbyId(uint _id,address _student) public payable  returns(uint) {
        Student s= Student(database.getstudentById(_id));
      s.Payfees.value(msg.value)(_student);
       
       
    }
    function getcheckFeesbyId(uint _id,address _student) public payable  returns(uint) {
        Student s= Student(database.getstudentById(_id));
      uint fees=s.callcheckfees(_student);
      return(fees);
       
       
    }
    
}