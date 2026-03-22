class UserPlanState{

  final bool isLoading;
  final bool cuponLoading;
  final bool paymentLoading;

  UserPlanState({
    this.isLoading = false,
    this.cuponLoading = false,
    this.paymentLoading = false,


});

  UserPlanState copyWith({
    bool? isLoading,
    bool? cuponLoading,
    bool? paymentLoading,
}){
    return UserPlanState(
      isLoading: isLoading?? this.isLoading,
      cuponLoading: cuponLoading??this.cuponLoading,
      paymentLoading: paymentLoading??this.paymentLoading
    );
}
}