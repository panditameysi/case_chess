import React from 'react'
import {  useNavigate } from 'react-router-dom'

const NavBar = () => {
  const navigate = useNavigate();
  return (
    <nav className='w-full bg-gray-200 text-3xl p-10 flex justify-between'>
      <h1>NavBar</h1>
      <div>
        <button className='custom-button' onClick={() => navigate('/')}>Home</button>
        <button className='custom-button' onClick={() => navigate('/add')}>Add</button>
        <button className='custom-button'  onClick={() => navigate('/performance')}>Performance</button>
        <button className='custom-button' onClick={()=>navigate('/average')}>Average</button>
      </div>
    </nav>
  )
}

export default NavBar