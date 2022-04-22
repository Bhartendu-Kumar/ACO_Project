function projected_input_vector = proj_u(vector_to_project, parameter_l)

projected_input_vector = (-parameter_l<=vector_to_project & vector_to_project<=parameter_l).*vector_to_project + (vector_to_project>parameter_l).*parameter_l + (vector_to_project<-parameter_l).*-parameter_l;

end